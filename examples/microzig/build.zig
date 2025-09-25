const std = @import("std");
const microzig = @import("microzig");

const MicroBuild = microzig.MicroBuild(.{ .stm32 = true });

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const mz_dep = b.dependency("microzig", .{});
    const mb = MicroBuild.init(b, mz_dep) orelse return;

    const fw = mb.add_firmware(.{
        .name = "uwb",
        .target = mb.ports.stm32.chips.STM32L071KZ,
        .optimize = optimize,
        .root_source_file = b.path("src/main.zig"),
    });
    const resolved_zig_target = b.resolveTargetQuery(fw.target.zig_target);

    const littlefs_dep = b.dependency("littlefs", .{
        .optimize = optimize,
        .target = resolved_zig_target,
    });

    // const foundation_dep = mz_dep.builder.dependency("modules/foundation-libc", .{});
    const foundation_dep = b.dependency("foundationlibc", .{
        .target = resolved_zig_target,
        .optimize = optimize,
    });
