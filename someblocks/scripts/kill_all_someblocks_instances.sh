#!/bin/bash
kill $(ps aux | grep someblocks | cut -d " " -f 8)
