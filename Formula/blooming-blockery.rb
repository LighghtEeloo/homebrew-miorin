class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.13/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "65a3a156bd538d5ed7b1ac5f9e6ffdb0faf4910ee00668ddef175de883a9c4b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.13/blooming-blockery-x86_64-apple-darwin.tar.xz"
      sha256 "b0f51e2636d6a43ab08c2c82f6237c900e3a073d6860730ede23e097cadadbed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.13/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "32de41ccee49ad469e62a8a299b27c756fadc90b270528aaa712559126d91918"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.13/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "714c556854f9890225bc26d3c5ae9188cb30c53a501490c0dd935a1eb0de04a2"
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
