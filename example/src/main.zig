const std = @import("std");
const lfs = @cImport(@cInclude("lfs.h"));

pub fn main() void {
    std.debug.print("Hello les touneys!\n", .{});
    const cfg: lfs.lfs_config = .{};

    std.debug.print("cfg : {any}\n", .{cfg});
}
