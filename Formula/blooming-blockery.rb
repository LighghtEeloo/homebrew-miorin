class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.25"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.25/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "df29579e67d67ab15dd5986998360599904436e08ca6088a3d93263a9cef7ade"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.25/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "361783aa69ba3b64a640634af77c9b4b38da30dc1e12d7d07da20ccf7d3eae79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.25/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e9d4c5af49c3cb5b8000afd4d18f6e2572e6d480ab3c2086ddbd23f1089fdfcf"
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
    bin.install "blooming-blockery" if OS.mac? && Hardware::CPU.arm?
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
