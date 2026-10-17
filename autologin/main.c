#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <grp.h>
#include <pwd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <linux/kd.h>
#include <linux/vt.h>
#include <security/pam_appl.h>

#ifdef UTMPX_ENABLED
#include <utmpx.h>
#include <time.h>

#define UT_NAMESIZE     16
#define UT_LINESIZE     8
#define UT_HOSTSIZE     16

#define DEV_PREFIX "/dev/"
#define TTY_PREFIX "/dev/tty"

static int utmp_login(const char *username, pid_t pid) {
	const char *tty = ttyname(STDIN_FILENO);
	if (tty == NULL || strncmp(tty, TTY_PREFIX, strlen(TTY_PREFIX)) != 0) {
		return -1;
	}

	struct utmpx entry = { 0 };
	entry.ut_type = USER_PROCESS;
	entry.ut_pid = pid;
	snprintf(entry.ut_user, UT_NAMESIZE, "%s", username);

	struct timespec time;
	clock_gettime(CLOCK_REALTIME, &time);
	entry.ut_tv.tv_sec = time.tv_sec;

	int ut_id = atoi(tty + strlen(TTY_PREFIX));
	snprintf(entry.ut_line, UT_LINESIZE, "%s", tty + strlen(DEV_PREFIX));
	snprintf(entry.ut_id, 4, "%d", ut_id);

	setutxent();
	pututxline(&entry);
	endutxent();

	return ut_id;
}

static void utmp_logout(int ut_id) {
	struct utmpx entry = { 0 };
	entry.ut_type = DEAD_PROCESS;
	snprintf(entry.ut_id, 4, "%d", ut_id);
	setutxent();
	pututxline(&entry);
	endutxent();
}

#else

static int utmp_login(const char *username, pid_t pid) {
	(void)username;
	(void)pid;
	return -1;
}
static void utmp_logout(int ut_id) {
	(void)ut_id;
}

#endif

static int check_errno(char *operation, int error) {
	if (error != -1)
		return error;
	fprintf(stderr, "%s failed: %s (%d)\n", operation, strerror(errno), errno);
	exit(EXIT_FAILURE);
}

static int check_pam(struct pam_handle *handle, char *operation, int error) {
	if (error == PAM_SUCCESS)
		return 0;
	fprintf(stderr, "%s failed: %s\n", operation, pam_strerror(handle, error));
	if (handle != NULL)
		pam_end(handle, error);
	exit(EXIT_FAILURE);
}

static int pam_null_conv(int num_msg, const struct pam_message** msg, struct pam_response** resp, void* appdata_ptr) {
	(void)msg;
	(void)appdata_ptr;
	*resp = calloc(num_msg, sizeof (struct pam_response));
	return *resp == NULL ? PAM_BUF_ERR : PAM_SUCCESS;
}

static int pam_putenv_tuple(struct pam_handle* handle, char* key, char* value) {
	char buf[256];
	snprintf(buf, sizeof buf, "%s=%s", key, value);
	return pam_putenv(handle, buf);
}

static void child_main(struct passwd *pwd, char **user_cmd, char** env) {
	check_errno("initgroups", initgroups(pwd->pw_name, pwd->pw_gid));
	check_errno("setgid", setgid(pwd->pw_gid));
	check_errno("setuid", setuid(pwd->pw_uid));
	check_errno("chdir", chdir(pwd->pw_dir));
	check_errno("prctl", prctl(PR_SET_PDEATHSIG, SIGTERM));

	execvpe(user_cmd[0], user_cmd, env);

	perror("execvpe failed");
	_exit(EXIT_FAILURE);
}

static char *getenv_or(char *key, char *or) {
	char *var = getenv(key);
	return var ? var : or;
}

int main(int argc, char *argv[]) {
	struct pam_conv conv = { pam_null_conv, NULL };
	struct pam_handle* handle = NULL;

	if (argc < 3) {
		fprintf(stderr, "invalid arguments\n");
		fprintf(stderr, "usage: %s username command...\n", argv[0]);
		return 1;
	}

	check_pam(handle, "pam_start", pam_start("autologin", argv[1], &conv, &handle));
	check_pam(handle, "pam_acct_mgmt", pam_acct_mgmt(handle, PAM_SILENT));
	check_pam(handle, "pam_setcred", pam_setcred(handle, PAM_ESTABLISH_CRED));

	struct passwd* pwd = getpwnam(argv[1]);
	if (pwd == NULL) {
		fprintf(stderr, "getpwnam failed\n");
		return 1;
	}

	check_pam(handle, "pam_putenv", pam_putenv(handle, "XDG_SEAT=seat0"));
	check_pam(handle, "pam_putenv", pam_putenv(handle, "XDG_SESSION_CLASS=user"));
	check_pam(handle, "pam_putenv", pam_putenv(handle, "XDG_VTNR=1"));
	check_pam(handle, "pam_putenv", pam_putenv_tuple(handle, "HOME", pwd->pw_dir));
	check_pam(handle, "pam_putenv", pam_putenv_tuple(handle, "PWD", pwd->pw_dir));
	check_pam(handle, "pam_putenv", pam_putenv_tuple(handle, "SHELL", pwd->pw_shell));
	check_pam(handle, "pam_putenv", pam_putenv_tuple(handle, "USER", pwd->pw_name));
	check_pam(handle, "pam_putenv", pam_putenv_tuple(handle, "LOGNAME", pwd->pw_name));
	check_pam(handle, "pam_putenv", pam_putenv_tuple(handle, "TERM", getenv_or("TERM", "linux")));

	check_pam(handle, "pam_open_session", pam_open_session(handle, PAM_SILENT));
	char** env = pam_getenvlist(handle);

	int ut_id = -1;
	pid_t pid = check_errno("fork", fork());
	if (pid == 0)
		child_main(pwd, &argv[2], env);

	ut_id = utmp_login(argv[1], pid);

	int res;
	while ((res = waitpid(pid, NULL, 0)) <= 0) {
		if (res == -1 && errno != EINTR) {
			fprintf(stderr, "waitpid failed: %s (%d)\n", strerror(errno), errno);
			break;
		}
	}

	if (ut_id != -1) {
		utmp_logout(ut_id);
	}

	check_pam(handle, "pam_close_session", pam_close_session(handle, PAM_SILENT));
	check_pam(handle, "pam_setcred", pam_setcred(handle, PAM_DELETE_CRED));
	check_pam(handle, "pam_end", pam_end(handle, 0));
	return 0;
}
