const std = @import("std");
const microzig = @import("microzig");
const lfs = @import("lfs");

pub fn main() void {
    const lfs_cfg: lfs.lfs_config = undefined;
    defer lfs_cfg.read_size = 0;
    while (true) {}
}
