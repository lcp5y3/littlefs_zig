const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "littlefs_example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    const littlefs_dep = b.dependency("littlefs", .{
        .target = target,
        .optimize = optimize,
        .stdlib = true,
    });
    exe.root_module.addImport("lfs", littlefs_dep.module("lfs"));
    exe.linkLibrary(littlefs_dep.artifact("littlefs"));

    b.installArtifact(exe);
}
