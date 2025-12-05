#!/bin/bash

rm src/config.hpp && cp src/config.def.hpp src/config.hpp
ninja -C build
sudo ninja -C build install
