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

You can also use `--with-i486` (x86 32-bit), `--with-aarch64` (ARM 64-bit), `--with-arm` (ARM soft-float) and `--with-mips`.

(Note: a custom build can take up to several hours, depending on the selected architectures and on the host CPU.)

Only tested on macOS Catalina.

## Troubleshooting

### running "musl-gcc"

As stated in [this issue](https://github.com/FiloSottile/homebrew-musl-cross/issues/16), some scripts expect the command `musl-gcc` to exist.
That said, you may want to have such symlink:

```
# if your cross compiler toolchain targets musl Linux amd64
ln -s $(which x86_64-linux-musl-gcc) /usr/local/bin/musl-gcc
```
