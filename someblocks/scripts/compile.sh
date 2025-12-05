#!/bin/bash
rm -f blocks.h && make && sudo make install
pkill someblocks #&& someblocks &
