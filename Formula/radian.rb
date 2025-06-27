class Radian < Formula
  include Language::Python::Virtualenv

  desc "A 21st century R console"
  homepage "https://github.com/randy3k/radian"
  url "https://github.com/randy3k/radian/archive/refs/tags/v0.6.15.zip"
  sha256 "24c63b2b3b592996cee7d82ad1f6ff022e4f4a6f2aec0d322a9197de96c46b80"
  license "MIT"

  depends_on "python@3.13"

  resource "rchitect" do
    url "https://files.pythonhosted.org/packages/c6/37/2778822c5b4d3181c022011817b47ff5f78a143083729965460464441bba/rchitect-0.4.8.tar.gz"
    sha256 "5ebea853fd05250a81957ee4cbd0739c80a7cbcd043dada81691c79e346b0f60"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/bb/6e/9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1c/prompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/72/3a/79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17a/jedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/radian", "--version"
  end
end
