# typed: false
# frozen_string_literal: true

class MuslCross < Formula
  desc "Linux cross compilers based on musl libc"
  homepage "https://github.com/richfelker/musl-cross-make"
  url "https://github.com/richfelker/musl-cross-make/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "306a66dd175d1065e6075deea02300d02e17806fb0a4d6f5e5829cf07c16eb51"
  head "https://github.com/richfelker/musl-cross-make.git"

  option "with-arm-hf", "Build cross-compilers targeting arm-linux-musleabihf"
  option "with-arm", "Build cross-compilers targeting arm-linux-musleabi"
  option "with-i486", "Build cross-compilers targeting i486-linux-musl"
  option "with-mips", "Build cross-compilers targeting mips-linux-musl"
  option "with-mipsel", "Build cross-compilers targeting mipsel-linux-musl"
  option "with-mips64", "Build cross-compilers targeting mips64-linux-musl"
  option "with-mips64el", "Build cross-compilers targeting mips64el-linux-musl"
  option "with-powerpc", "Build cross-compilers targeting powerpc-linux-musl"
  option "with-powerpc-sf", "Build cross-compilers targeting powerpc-linux-muslsf"
  option "with-powerpc64", "Build cross-compilers targeting powerpc64-linux-musl"
  option "with-powerpc64le", "Build cross-compilers targeting powerpc64le-linux-musl"
  option "with-riscv64", "Build cross-compilers targeting riscv64-linux-musl"
  option "without-aarch64", "Do not build cross-compilers targeting aarch64-linux-musl"
  option "without-x86_64", "Do not build cross-compilers targeting x86_64-linux-musl"

  depends_on "gnu-sed" => :build
  depends_on "make" => :build

  resource "linux-headers-4.19.88-2.tar.xz" do
    url "https://ftp.barfooze.de/pub/sabotage/tarballs/linux-headers-4.19.88-2.tar.xz"
    sha256 "dc7abf734487553644258a3822cfd429d74656749e309f2b25f09f4282e05588"
  end

  resource "mpfr-4.0.2.tar.bz2" do
    url "https://ftpmirror.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.bz2"
    sha256 "c05e3f02d09e0e9019384cdd58e0f19c64e6db1fd6f5ecf77b4b1c61ca253acc"
  end

  resource "mpc-1.1.0.tar.gz" do
    url "https://ftpmirror.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz"
    sha256 "6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e"
  end

  resource "gmp-6.1.2.tar.bz2" do
    url "https://ftpmirror.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2"
    sha256 "5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2"
  end

  resource "musl-1.2.5.tar.gz" do
    url "https://musl.libc.org/releases/musl-1.2.5.tar.gz"
    sha256 "a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4"
  end

  resource "binutils-2.44.tar.bz2" do
    url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
    sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  end

  resource "config.sub" do
    url "https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=3d5db9ebe860"
    sha256 "75d5d255a2a273b6e651f82eecfabf6cbcd8eaeae70e86b417384c8f4a58d8d3"
  end

  resource "gcc-14.2.0.tar.xz" do
    url "https://ftpmirror.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
    sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"
  end

  resource "isl-0.21.tar.bz2" do
    url "https://downloads.sourceforge.net/project/libisl/isl-0.21.tar.bz2"
    sha256 "d18ca11f8ad1a39ab6d03d3dcb3365ab416720fcb65b42d69f34f51bf0a0e859"
  end

  patch do # add hash and forward-ported patches for binutils 2.44
    # for riscv64, see https://github.com/richfelker/musl-cross-make/issues/204
    url "https://github.com/richfelker/musl-cross-make/commit/83b03366.patch?full_index=1"
    sha256 "cb89de12c43d2fedf6cba2ad92505e3e2a609cc8339fb08700c90b1103963b33"
  end

  def install
    targets = []
    targets.push "x86_64-linux-musl" if build.with? "x86_64"
    targets.push "aarch64-linux-musl" if build.with? "aarch64"
    targets.push "arm-linux-musleabihf" if build.with? "arm-hf"
    targets.push "arm-linux-musleabi" if build.with? "arm"
    targets.push "i486-linux-musl" if build.with? "i486"
    targets.push "mips-linux-musl" if build.with? "mips"
    targets.push "mipsel-linux-musl" if build.with? "mipsel"
    targets.push "mips64-linux-musl" if build.with? "mips64"
    targets.push "mips64el-linux-musl" if build.with? "mips64el"
    targets.push "powerpc-linux-musl" if build.with? "powerpc"
    targets.push "powerpc-linux-muslsf" if build.with? "powerpc-sf"
    targets.push "powerpc64-linux-musl" if build.with? "powerpc64"
    targets.push "powerpc64le-linux-musl" if build.with? "powerpc64le"
    targets.push "riscv64-linux-musl" if build.with? "riscv64"

    (buildpath/"resources").mkpath
    resources.each do |resource|
      cp resource.fetch, buildpath/"resources"/resource.name
    end

    (buildpath/"config.mak").write <<~EOS
      SOURCES = #{buildpath/"resources"}
      OUTPUT = #{libexec}
      GCC_VER = 14.2.0
      BINUTILS_VER = 2.44

      # Drop some features for faster and smaller builds
      COMMON_CONFIG += --disable-nls
      GCC_CONFIG += --disable-libquadmath --disable-decimal-float
      GCC_CONFIG += --disable-libitm --disable-fixed-point

      # Keep the local build path out of binaries and libraries
      COMMON_CONFIG += --with-debug-prefix-map=#{buildpath}=

      # Explicitly enable libisl support to avoid opportunistic linking
      ISL_VER = 0.21

      # Use system zlib to avoid build failures on macOS 15+
      # https://sourceware.org/bugzilla/show_bug.cgi?id=32935
      BINUTILS_CONFIG += --with-system-zlib
      GCC_CONFIG += --with-system-zlib
    EOS

    ENV.prepend_path "PATH", "#{Formula["gnu-sed"].opt_libexec}/gnubin"
    targets.each do |target|
      system Formula["make"].opt_bin/"gmake", "install", "TARGET=#{target}"
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # Clear CPATH which Homebrew sets to include macOS SDK headers
    # (which don't support riscv64, aarch64-linux, etc.)
    ENV.delete "CPATH"

    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>

      int main()
      {
          printf("Hello, world!");
      }
    EOS

    system "#{bin}/x86_64-linux-musl-cc", (testpath/"hello.c") if build.with? "x86_64"
    system "#{bin}/i486-linux-musl-cc", (testpath/"hello.c") if build.with? "i486"
    system "#{bin}/aarch64-linux-musl-cc", (testpath/"hello.c") if build.with? "aarch64"
    system "#{bin}/arm-linux-musleabihf-cc", (testpath/"hello.c") if build.with? "arm-hf"
    system "#{bin}/arm-linux-musleabi-cc", (testpath/"hello.c") if build.with? "arm"
    system "#{bin}/mips-linux-musl-cc", (testpath/"hello.c") if build.with? "mips"
    system "#{bin}/mipsel-linux-musl-cc", (testpath/"hello.c") if build.with? "mipsel"
    system "#{bin}/mips64-linux-musl-cc", (testpath/"hello.c") if build.with? "mips64"
    system "#{bin}/mips64el-linux-musl-cc", (testpath/"hello.c") if build.with? "mips64el"
    system "#{bin}/powerpc-linux-musl-cc", (testpath/"hello.c") if build.with? "powerpc"
    system "#{bin}/powerpc-linux-muslsf-cc", (testpath/"hello.c") if build.with? "powerpc-sf"
    system "#{bin}/powerpc64-linux-musl-cc", (testpath/"hello.c") if build.with? "powerpc64"
    system "#{bin}/powerpc64le-linux-musl-cc", (testpath/"hello.c") if build.with? "powerpc64le"
    system "#{bin}/riscv64-linux-musl-cc", (testpath/"hello.c") if build.with? "riscv64"
  end
end
