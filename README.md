# homebrew-musl-cross

**One-click static-friendly musl-based GCC macOS-to-Linux cross-compilers**
based on [richfelker/musl-cross-make](https://github.com/richfelker/musl-cross-make).

```
brew install filosottile/musl-cross/musl-cross
```

By default it will install full cross compiler toolchains targeting musl Linux amd64 and arm64.

You can then use `x86_64-linux-musl-` or `aarch64-linux-musl-` versions of the
tools to build for the target. For example `x86_64-linux-musl-cc` will compile C
code to run on musl Linux amd64.

The "musl" part of the target is important: the binaries will ONLY run on a
musl-based system, like Alpine. However, if you build them as static binaries by
passing `-static` as an LDFLAG they will run anywhere. Musl is specifically
engineered to support static binaries.

To use this as a Go cross-compiler for cgo, use `CC`, `GOOS`/`GOARCH`,
`CGO_ENABLED`, and `-extldflags`.

```
CC=x86_64-linux-musl-gcc CGO_ENABLED=1 GOOS=linux GOARCH=amd64 \
    go build -trimpath -ldflags "-extldflags -static"
```

To use this with Rust, add an entry to `.cargo/config` and use the corresponding target.

```
[target.x86_64-unknown-linux-musl]
linker = "x86_64-linux-musl-gcc"
```

Other architectures are supported. For example you can build a Raspberry Pi cross-compiler:

```
brew install filosottile/musl-cross/musl-cross --build-from-source \
    --without-x86_64 --without-aarch64 --with-arm-hf
```

(Note: a custom build takes around ten minutes per architecture on an M2.
The installed size is between 150MB and 300MB per architecture.)

If you encounter issues with a missing `musl-gcc` binary, the build system might
be [assuming the presence of the musl host compiler
wrapper](https://github.com/FiloSottile/homebrew-musl-cross/issues/16). That
should be reported as an issue, but you might be able to workaround it by
creating a symlink:

```
ln -s "$(brew --prefix musl-cross)/bin/x86_64-linux-musl-gcc" /usr/local/bin/musl-gcc
```
