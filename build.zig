const std = @import("std");

pub fn build(b: *std.Build) void {
    const lfs_dep = b.dependency("littlefs", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const stdlib = b.option(bool, "stdlib", "link to stdlib") orelse false;
    const log_en = b.option(bool, "log_enable", "Enable logging function") orelse false;

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
    lfs_translate.addIncludePath(lfs_dep.path(""));
    const lfs_translate_mod = lfs_translate.createModule();

    if (log_en == false) {
        lfs_lib.root_module.addCMacro("LFS_NO_DEBUG", "1");
        lfs_lib.root_module.addCMacro("LFS_NO_WARN", "1");
        lfs_lib.root_module.addCMacro("LFS_NO_ERROR", "1");
        lfs_lib.root_module.addCMacro("LFS_NO_MALLOC", "1");

        lfs_translate.defineCMacro("LFS_NO_DEBUG", "1");
        lfs_translate.defineCMacro("LFS_NO_WARN", "1");
        lfs_translate.defineCMacro("LFS_NO_ERROR", "1");
        lfs_translate.defineCMacro("LFS_NO_MALLOC", "1");
    }

    lfs_lib.root_module.addImport("lfs", lfs_translate_mod);
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
