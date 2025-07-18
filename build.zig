const std = @import("std");

pub fn build(b: *std.Build) void {
    const littlefs_dep = b.dependency("littlefs", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const littlefs = b.addStaticLibrary(.{
        .name = "littlefs",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    littlefs.addCSourceFile(.{
        .file = littlefs_dep.path("lfs.c"),
        .flags = &.{},
    });
    littlefs.addIncludePath(littlefs_dep.path(""));
    littlefs.installHeader(
        littlefs_dep.path("lfs.h"),
        "lfs.h",
    );
    b.installArtifact(littlefs);
}
