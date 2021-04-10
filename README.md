# homebrew-musl-cross

**One-click static-friendly musl-based GCC macOS-to-Linux cross-compilers**
based on [richfelker/musl-cross-make](https://github.com/richfelker/musl-cross-make).

```
brew install FiloSottile/musl-cross/musl-cross
```

By default it will build a full cross compiler toolchain targeting musl Linux amd64.

You can then use `x86_64-linux-musl-` versions of the tools to build for the target.
For example `x86_64-linux-musl-cc` will compile C code to run on musl Linux amd64.

The "musl" part of the target is important: the binaries will ONLY run on a musl-based system, like Alpine.
However, if you build them as static binaries by passing `-static` as an LDFLAG they will run **anywhere**.
Musl is specifically engineered to support static binaries.

Other architectures are supported. For example you can build a Raspberry Pi cross-compiler:

```
brew install FiloSottile/musl-cross/musl-cross --without-x86_64 --with-arm-hf
```

You can also use `--with-i486` (x86 32-bit), `--with-aarch64` (ARM 64-bit), `--with-arm` (ARM soft-float), `--with-mips` and `--with-powerpc`.

(Note: a custom build can take up to several hours and gigabytes of disk space, depending on the selected architectures and on the host CPU. The default installed size is between 200MB and 300MB.)

Only tested on macOS Catalina.
