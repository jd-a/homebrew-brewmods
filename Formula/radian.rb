class Radian < Formula
  include Language::Python::Virtualenv

  desc "A 21st century R console"
  homepage "https://github.com/randy3k/radian"
  url "https://github.com/randy3k/radian/archive/refs/tags/v0.6.15.zip"
  sha256 "24c63b2b3b592996cee7d82ad1f6ff022e4f4a6f2aec0d322a9197de96c46b80"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/radian", "--version"
  end
end
