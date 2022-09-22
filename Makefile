.DEFAULT_GOAL:=all
SHELL=/bin/bash

BIN_DIR:=./bin
BUILD_DIR:=./build
OBJS_DIR:=$(BUILD_DIR)/objs
BIN:=$(BIN_DIR)/a.out

SRCS:=$(wildcard src/*.c)
INCLUDE=$(wildcard include/*.h)
OBJS:=$(patsubst %.c,$(OBJS_DIR)/%.o,$(SRCS))

CC=gcc
LD=gcc
CFLAGS:=-I./include/ -Wextra -Wall -Wpedantic
ifdef DEBUG
	CFLAGS+=-g -Werror -O1
else # Release
	CFLAGS+=-Werror -O2
endif
LDFLAGS=
LIBS=

.SECONDEXPANSION:
$(OBJS_DIR)/%.o: %.c $$(INCLUDE)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BIN): $(OBJS)
	$(LD) -o $@ $^ $(LIBS) $(LDFLAGS)

all: $(BIN)

run: $(BIN)
	$(BIN)

clean:
	git clean -fxd -n

format:
	find ./src -type f \( -name '*.c' -o -name '*.h' \)  -exec clang-format -i {} +

.PHONY: clean format run build
