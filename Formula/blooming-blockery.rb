class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.2/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "6fc6f13b7e305c9a88e6710ae109ba4c5bef20196705922ddb3a573a749518f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.2/blooming-blockery-x86_64-apple-darwin.tar.xz"
      sha256 "3e6df7a3afff578aeec91d5482f2f02ec6870b98f5e60296e04d8f6d3613cbc8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.2/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3491160cc44c7e181d0ac04fa2ba521f4f994e88dca12a8049e29cdb8d0f6f72"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.2/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05cb4e675bebf5e134b3139d874e1c9e70fc3b843781bb943c1bfc3fe26550eb"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "blooming-blockery" if OS.mac? && Hardware::CPU.arm?
    bin.install "blooming-blockery" if OS.mac? && Hardware::CPU.intel?
    bin.install "blooming-blockery" if OS.linux? && Hardware::CPU.arm?
    bin.install "blooming-blockery" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
