class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "8bbd591360f03c46379dec24020941c0138204f7b19612fe4d94d8064390c2dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-x86_64-apple-darwin.tar.xz"
      sha256 "82e74c5c2521a297b363d7526b09562c544c929f85ee39c4c9de8e1d3152b9fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1d4e926a7a253b2b07cd0b3a2513db2c9cfe10e0d8e5d573388d23204e31c3fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c4d144dec990aafaf29119da9abb27864d1235028e7187afe65e54d0d40de393"
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
