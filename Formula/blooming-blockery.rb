class BloomingBlockery < Formula
  desc "A structured document editor for designers and developers."
  homepage "https://github.com/photonfoxlime/bb"
  version "0.0.26"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.26/blooming-blockery-aarch64-apple-darwin.tar.xz"
      sha256 "f9c058544264946a45da1c132b18df13697ed21727c846c55735cac904230154"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.26/blooming-blockery-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1afe52d2da565844646e79184c65d41cf64d0fe8b667e942773e30389edd19ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/photonfoxlime/bb/releases/download/v0.0.26/blooming-blockery-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "df74e973984b23a62ef8a91af6380bc7f3d20938fef96b15a2dcf94e6ec77661"
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
