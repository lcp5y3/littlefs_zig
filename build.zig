const std = @import("std");

pub fn build(b: *std.Build) !void {
    const lfs_dep = b.dependency("littlefs", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const stdlib = b.option(bool, "stdlib", "link with stdlib") orelse false;
    const stdlib_header = b.option(std.Build.LazyPath, "stdlib_header", "Inc dir of your own stdlib");
    const log_enable = b.option(bool, "log_enable", "Enable logging function") orelse false;
    const malloc_enable = b.option(bool, "malloc_enable", "Allowing used of malloc in littlefs") orelse false;

    const lfs_lib = b.addLibrary(.{
        .name = "littlefs",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = stdlib,
        }),
        .linkage = .static,
    });

    lfs_lib.root_module.addIncludePath(lfs_dep.path(""));
    lfs_lib.root_module.addCSourceFiles(.{
        .root = lfs_dep.path(""),
        .files = &.{ "lfs.c", "lfs_util.c" },
        .flags = &.{},
    });
    // use TranslateC to generate a module
    const lfs_translate = b.addTranslateC(.{
        .root_source_file = lfs_dep.path("lfs.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = stdlib,
    });
    const lfs_translate_mod = lfs_translate.addModule("lfs");

    // If you want to use a custom stdlib
    if (stdlib == false) {
        if (stdlib_header) |header| {
            lfs_translate.addIncludePath(header);
        }
    }

    // logging management
    if (log_enable == false) {
        lfs_lib.root_module.addCMacro("LFS_NO_DEBUG", "1");
        lfs_lib.root_module.addCMacro("LFS_NO_WARN", "1");
        lfs_lib.root_module.addCMacro("LFS_NO_ERROR", "1");

        lfs_translate.defineCMacro("LFS_NO_DEBUG", "1");
        lfs_translate.defineCMacro("LFS_NO_WARN", "1");
        lfs_translate.defineCMacro("LFS_NO_ERROR", "1");
        lfs_translate_mod.addCMacro("LFS_NO_DEBUG", "1");
        lfs_translate_mod.addCMacro("LFS_NO_WARN", "1");
        lfs_translate_mod.addCMacro("LFS_NO_ERROR", "1");
    }

    // dynamic allocation management
    if (malloc_enable == false) {
        lfs_lib.root_module.addCMacro("LFS_NO_MALLOC", "1");

        lfs_translate.defineCMacro("LFS_NO_MALLOC", "1");
        lfs_translate_mod.addCMacro("LFS_NO_MALLOC", "1");
    }
    lfs_translate_mod.addIncludePath(lfs_dep.path(""));
    lfs_translate_mod.addCSourceFiles(.{
        .root = lfs_dep.path(""),
        .files = &.{ "lfs.c", "lfs_util.c" },
        .flags = &.{},
    });

    lfs_lib.installHeader(
        lfs_dep.path("lfs.h"),
        "lfs.h",
    );
    lfs_lib.installHeader(
        lfs_dep.path("lfs_util.h"),
        "lfs_util.h",
    );
    b.installArtifact(lfs_lib);
}
