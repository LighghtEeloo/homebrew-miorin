class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "0be71fd35280208acb0362a9aa2ca92797f2b3e348ee3f57122c47f0bcfe2446"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-x86_64-apple-darwin.tar.xz"
      sha256 "40f26ee1862479e2789be0e94cf6f3f7a3e7f21827b6888ea584218210d1670b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "393e5f4e8b9ae4343bcde605727ddf41e5d1dd8196bd32308d8a35d0a6e5d9b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.4/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bd75857306b3306fc370e9d39363b5e0396164b67fcbc65f6729c4f14fd16dac"
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
