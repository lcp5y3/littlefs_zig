# littlefs

Porting [littlefs](https://github.com/littlefs-project/littlefs) to zig build system.

I'm porting littlefs with embedded target in mind, so the main goal is to use it with microzig.

## Build interface

To allowing you to use little fs with a target with no c std lib available,
I have add few option to the build script.

 - `stdlib`: a boolean, if true the build.zig will try to link little fs with C std lib
 - `stdlib_header`: `LazyPath`, if stdlib is set to False, this let you specify where little fs can find
   C stdlib header. This is usefull if you use a custom C stdlib like
   [foundation](https://github.com/ZigEmbeddedGroup/microzig/tree/main/modules/foundation-libc)
 - `log_enable`: boolean, this one enable or not the logging functionnality of little fs. False by default
 - `malloc_enable`: boolean, same as previous one but for dynamic allocation. False by default

## How To Use

### With system libc

To use little fs in a project that target a target with std lib available, you should:

And this to your build.zig:

```zig
  cont exe = b.addExecutable(.{YourProjectConfig});

  const littlefs_dep = b.dependency("littlefs", .{
      .target = target,
      .optimize = optimize,
      .stdlib = true,
  });
  exe.root_module.addImport("lfs", littlefs_dep.module("lfs"));
  exe.linkLibrary(littlefs_dep.artifact("littlefs"));
```

After that you can call little fs in your project:

```zig
const lfs = @import("lfs");

pub fn main() void{
    const cfg: lfs.lfs_config = .{};

    std.debug.print("cfg : {any}\n", .{cfg});
}
```

I you want more information you can take a look at [this example](./examples/host).

### With custom libc

To allow the use of little fs in embedded mcu, I had ability to let user manage libc
link of little fs. Do to that, you must link little fs with libc in your own build.zig
and you must pass to the module the path of your libc header (thank's to `stdlib_header` option).

For more informations you can take a look at [this example](./examples/microzig) which
use microzig foundation libc.
