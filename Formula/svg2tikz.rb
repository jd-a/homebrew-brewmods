class Svg2tikz < Formula
  include Language::Python::Virtualenv

  desc "Tool for converting SVG graphics to TikZ/PGF code"
  homepage "https://xyz2tex.github.io/svg2tikz/"
  url "https://github.com/xyz2tex/svg2tikz/archive/refs/tags/v3.3.6.tar.gz"
  sha256 "60a8f8f235ea02c347f85664ca72b4177e1830ef218a7f9e4ec2cfd1b9bdcfef"
  license "GPL-2.0-or-later"
  revision 1

  depends_on "pkgconf" => :build

  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.15"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "inkex" do
    url "https://files.pythonhosted.org/packages/48/de/bb8fecc38c2925f105b745ddfe35388c921bc3a5e9014325254451ab4af7/inkex-1.4.1-py3-none-any.whl"
    sha256 "5039af02a834144cd9373448bb81c9d657319e5734dc8db0609bb306cbcf2726"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/c8/8b/dc32df939ab541fca6ee8964d26aa231dbe231cdc2b2713228161441ba9c/cssselect-1.6.0.tar.gz"
    sha256 "8c83a7139e97b93aa5ebdc0f46e785f7056a08a8bf201e597a6a2629d7eb11db"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "pyserial" do
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
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/svg2tikz --version")

    # Verify that Python dependencies supplied by Homebrew are visible
    # inside svg2tikz's virtualenv.
    system libexec/"bin/python", "-c", "import cairo, gi, lxml, numpy, PIL"

    # Exercise an actual SVG -> TikZ conversion rather than only
    # checking whether the entry point starts.
    (testpath/"test.svg").write <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg"
           width="10"
           height="10"
           viewBox="0 0 10 10">
        <path d="M 1 1 L 9 9" fill="none" stroke="black"/>
      </svg>
    SVG

    output = shell_output(
      "#{bin}/svg2tikz --codeoutput codeonly #{testpath}/test.svg",
    )
    assert_match "\\path", output
  end
end
