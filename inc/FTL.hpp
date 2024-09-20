#pragma once

#ifdef LINUX

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

extern int main(int argc, char *argv[]);
extern void arg(int argc, char argv[]);

#include <fuse.h>
// #include <unistd.h>
// #include <sys/types.h>
// #include <time.h>
// #include <string.h>

#endif  // LINUX
