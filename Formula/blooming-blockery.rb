class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.15/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "fa33e87bec88ab45d70c6d03a8cf814888af074a4c527fe47110ad909001962d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.15/blooming-blockery-x86_64-apple-darwin.tar.xz"
      sha256 "3db7eab160d6e311d632d2dab7a5bab9595d8f1cf3ea345c1da7bba3c0161339"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.15/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "385e6f4083c5ee256423a6d473cd62bf081a3d39c059a97a79780284175b1716"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.15/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1507fe110e62015f26a290056abd2dcb791e37f4b581f0cd092b5def0aae47b7"
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
