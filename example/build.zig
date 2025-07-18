const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "littlefs_example",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const littlefs_dep = b.dependency("littlefs", .{
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibrary(littlefs_dep.artifact("littlefs"));

    b.installArtifact(exe);
}
