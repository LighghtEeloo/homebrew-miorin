class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.10/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "5423cac7bf33d5ba5337fb8fefc1bea00bc4001274205da0a75d85fbbcfb7a8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.10/blooming-blockery-x86_64-apple-darwin.tar.xz"
      sha256 "73f21fc354507763b5780fda4fa6efbc0334917f559f9a1985a2882bb32c73ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.10/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "36a8ec6733d46ebbb99d844d4f71c9f48ce6cf29ab5c949ecfac779de2bc907e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.10/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28d03d3f105b142a56be6178d03fc4feca61480f15c2f7063b8f2b7d635946a4"
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
