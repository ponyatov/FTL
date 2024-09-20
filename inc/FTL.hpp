#pragma once

#ifdef LINUX

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/// @brief program entry point
/// @param argc number of command line arguments
/// @param argv command line arguments
/// @return 0
extern int main(int argc, char *argv[]);

/// @brief print single command line argument
/// @param argc index
/// @param argv value
extern void arg(int argc, char argv[]);

#define FUSE_USE_VERSION 30
#include <fuse.h>
#include <sys/errno.h>
// #include <unistd.h>
// #include <sys/types.h>
// #include <time.h>
// #include <string.h>

#endif  // LINUX
