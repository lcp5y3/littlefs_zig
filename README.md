# littlefs

Porting [littlefs](https://github.com/littlefs-project/littlefs) to zig build system.

I'm porting littlefs with embedded target in mind, so the main goal is to use it with microzig.

## Note

Logging and dynamic allocation are based on `<stdio.h>` and this library isn't available in
[microzig foundation-libc](https://github.com/ZigEmbeddedGroup/microzig/tree/main/modules/foundation-libc)
so the `build.zig` define the following C Macro to avoid this calls:

 - `LFS_NO_DEBUG`
 - `LFS_NO_WARN`
 - `LFS_NO_ERROR`
 - `LFS_NO_MALLOC`




