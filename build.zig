const std = @import("std");

pub fn build(b: *std.Build) void {
    const littlefs_dep = b.dependency("littlefs", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const littlefs = b.addLibrary(.{
        .name = "littlefs",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = false,
        }),
        .linkage = .static,
    });
    littlefs.root_module.addCMacro("LFS_NO_DEBUG", "1");
    littlefs.root_module.addCMacro("LFS_NO_ERROR", "1");
    littlefs.root_module.addCMacro("LFS_NO_WARN", "1");
    littlefs.root_module.addCMacro("LFS_NO_MALLOC", "1");

    littlefs.addCSourceFile(.{
        .file = littlefs_dep.path("lfs.c"),
        .flags = &.{},
    });
    littlefs.addCSourceFile(.{
        .file = littlefs_dep.path("lfs_util.c"),
        .flags = &.{},
    });
    littlefs.addIncludePath(littlefs_dep.path(""));
    littlefs.installHeader(
        littlefs_dep.path("lfs.h"),
        "lfs.h",
    );
    littlefs.installHeader(
        littlefs_dep.path("lfs_util.h"),
        "lfs_util.h",
    );
    b.installArtifact(littlefs);
}
