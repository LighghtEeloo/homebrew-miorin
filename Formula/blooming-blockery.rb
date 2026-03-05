class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.16"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.16/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "0ca900821f01e3a5f440c6f50bb702dcfb6ea4838b1194cc4eb49e01042812f8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.16/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "134769ccaa55c51a5d795c68ec103ec21c54a101f1a4452ef7c2274fdc1239eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.16/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4cb915579a33c26a5d7474231c9598535965f8f313980556ee130a1d2310cffb"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "bb", "blooming-blockery" if OS.mac? && Hardware::CPU.arm?
    bin.install "bb", "blooming-blockery" if OS.linux? && Hardware::CPU.arm?
    bin.install "bb", "blooming-blockery" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
