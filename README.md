# homebrew-musl-cross

**One-click static-friendly musl-based GCC OS X-to-Linux cross-compilers.**

```
brew install FiloSottile/musl-cross/musl-cross
```

By default it will build a full cross compiler toolchain targeting musl Linux amd64.
(It takes a while, a cup of coffee won't do. Going for a run might if you are more fit than me.)

You can then use `x86_64-linux-musl-` versions of the tools to build for the target.
For example `x86_64-linux-musl-cc` will compile C code to run on musl Linux amd64.

The "musl" part of the target is important: the binaries will ONLY run on a musl-based system, like Alpine.
However, if you build them as static binaries by passing `-static` as a LDFLAG they will run **anywhere**.
Musl is specifically engineered to support static binaries.

Other architectures are supported. For example to get a Raspberry Pi cross-compiler use:

```
brew install --HEAD https://gist.github.com/FiloSottile/01d2bbfaf63ae1b6e373e6bc874fefc6/raw/musl-cross.rb --without-x86_64 --with-arm-hf
```

You can also use `--with-i486` (x86 32-bit) and `--with-arm` (ARM soft-float).
