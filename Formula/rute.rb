class Rute < Formula
  desc "Map local domains to ports over HTTPS (nginx + mkcert + /etc/hosts)"
  homepage "https://github.com/haiigas/homebrew-rute"
  url "https://github.com/haiigas/homebrew-rute/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1ce092c180b9be789d3fe41c61967d10a5c38897e1c63f91802077167b7b8625"
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
