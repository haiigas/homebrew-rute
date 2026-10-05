class Rute < Formula
  desc "Map local domains to ports over HTTPS (nginx + mkcert + /etc/hosts)"
  homepage "https://github.com/haiigas/homebrew-rute"
  url "https://github.com/haiigas/homebrew-rute/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "UPDATE_ME_AFTER_TAGGING"
  license "MIT"

  depends_on "nginx"
  depends_on "mkcert"

  def install
    bin.install "bin/rute"
  end

  test do
    assert_match "rute 0.1.0", shell_output("#{bin}/rute --version")
  end
end
