class Svg2tikz < Formula
  include Language::Python::Virtualenv

  desc "Tool for converting SVG graphics to TikZ/PGF code"
  homepage "https://xyz2tex.github.io/svg2tikz/"
  url "https://github.com/xyz2tex/svg2tikz/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "e9754c38dd78ce142e83eb3779e71686b1b22ab54e4d7953224279c7f578bc15"
  license "GPL-2.0-or-later"

  depends_on "python@3.13"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "numpy"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "pkg-config" => :build

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  resource "inkex" do
    url "https://files.pythonhosted.org/packages/9c/a8/ef5b5776e8f2a05e2eff2c9b6acf2ea8e90a9af5d29f0841a8ac5111ce60/inkex-1.4.1.tar.gz"
    sha256 "2f9803154806ebae8a40b33ef2c691806a472857adc90303eaa32482bd8c19ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/72/0a/c3ea9573b1dc2e151abfe88c7fe0c26d1892fe6ed02d0cdb30f0d57029d5/cssselect-1.3.0.tar.gz"
    sha256 "57f8a99424cfab289a1b6a816a43075a4b00948c86b4dcf3ef4ee7e15f7ab0c7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/98/c9/b4594e6a81371dfa9eb7a2c110ad682acf985d96115ae8b25a1d63b4bf3b/pyparsing-3.2.4.tar.gz"
    sha256 "fff89494f45559d0f2ce46613b419f632bbb6afbdaed49696d322bcf98a58e99"
  end

  resource "pySerial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "scour" do
    url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
    sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/7a/fd/7a5ee21fd08ff70d3d33a5781c255cbe779659bd03278feb98b19ee550f4/tinycss2-1.4.0.tar.gz"
    sha256 "10c0972f6fc0fbee87c3edb76549357415e94548c1ae10ebccdea16fb404a9b7"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end
  
  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"svg2tikz", "--version"
  end
end
