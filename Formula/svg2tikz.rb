class Svg2tikz < Formula
  include Language::Python::Virtualenv

  desc "Tool for converting SVG graphics to TikZ/PGF code"
  homepage "https://xyz2tex.github.io/svg2tikz/"
  url "https://github.com/xyz2tex/svg2tikz/archive/refs/tags/v3.3.6.tar.gz"
  sha256 "60a8f8f235ea02c347f85664ca72b4177e1830ef218a7f9e4ec2cfd1b9bdcfef"
  license "GPL-2.0-or-later"

  depends_on "python@3.14"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "numpy"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "pkg-config" => :build

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "inkex" do
    url "https://files.pythonhosted.org/packages/9c/a8/ef5b5776e8f2a05e2eff2c9b6acf2ea8e90a9af5d29f0841a8ac5111ce60/inkex-1.4.1.tar.gz"
    sha256 "2f9803154806ebae8a40b33ef2c691806a472857adc90303eaa32482bd8c19ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/ec/2e/cdfd8b01c37cbf4f9482eefd455853a3cf9c995029a46acd31dfaa9c1dd6/cssselect-1.4.0.tar.gz"
    sha256 "fdaf0a1425e17dfe8c5cf66191d211b357cf7872ae8afc4c6762ddd8ac47fc92"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
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
    url "https://files.pythonhosted.org/packages/a3/ae/2ca4913e5c0f09781d75482874c3a95db9105462a92ddd303c7d285d3df2/tinycss2-1.5.1.tar.gz"
    sha256 "d339d2b616ba90ccce58da8495a78f46e55d4d25f9fd71dfd526f07e7d53f957"
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
