#ifndef LINUX
#error Linux-specific code only
#endif  // LINUX

#include "FTL.hpp"

int fuse_fs_getattr(const char *path, struct stat *st) {  //
    return -ENOSYS;
}

int readdir(const char *, void *, fuse_fill_dir_t, off_t,
            struct fuse_file_info *) {  //
    return -ENOSYS;
}

// int fuse_fs_getattr() { return -ENOSYS; }
// ... but
// int fuse_fs_open() { return 0; }
// int fuse_fs_release() { return 0; }
// int fuse_fs_opendir() { return 0; }
// int fuse_fs_releasedir() { return 0; }
// int fuse_fs_statfs() { return 0; }

struct fuse_operations operations = {
    .getattr = fuse_fs_getattr,
    .readdir = readdir  //
};

int main(int argc, char *argv[]) {
    arg(0, argv[0]);
    for (int i = 1; i < argc; i++) {  //
        arg(i, argv[i]);
    }
    return fuse_main(argc, argv, &operations, NULL);
}

void arg(int argc, char argv[]) {  //
    fprintf(stderr, "argv[%i] = <%s>\n", argc, argv);
}
