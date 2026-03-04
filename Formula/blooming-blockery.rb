class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.14/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "821dff3cb133f9c6951849a712d7cd00458038f5f596825f8c31aedf9848e3ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.14/blooming-blockery-x86_64-apple-darwin.tar.xz"
      sha256 "cd6f4c63b91b8588fabe0137c2924f37367855fe003da1030db5507f3594f65e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.14/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "145aab8e5f996a8441c78a957bb75b05d123da3d93115106e6b0ea37f2d5d418"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.14/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ce2d67dd39ce88f121678a93efc68bb882268c3d2b98ab2292e85196e30df656"
    end
  end
  license "Apache-2.0"

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
    bin.install "bb", "blooming-blockery" if OS.mac? && Hardware::CPU.arm?
    bin.install "bb", "blooming-blockery" if OS.mac? && Hardware::CPU.intel?
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
