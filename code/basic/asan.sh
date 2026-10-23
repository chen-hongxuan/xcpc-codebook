#!/bin/bash
g++ "$1" -pedantic -std=c++20 -O1 \
  -pipe -Wall -Wextra -Wshadow -Wconversion \
  -fsanitize=address,undefined \
  -fno-omit-frame-pointer \
  -fsanitize-address-use-after-scope \
  -fstack-protector-strong -g -o a.out -lm
