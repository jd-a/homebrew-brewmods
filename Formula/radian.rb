class Radian < Formula
  include Language::Python::Virtualenv

  desc "R console for the 21st century"
  homepage "https://github.com/randy3k/radian"
  url "https://github.com/randy3k/radian/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ad92b7601cfd955ab1304bf40c76ccae22a88148305253a94d9ef71dbb5ae959"
  license "MIT"

  depends_on "python@3.15"

  resource "rchitect" do
    url "https://files.pythonhosted.org/packages/16/e3/eb876bb94db13b6ac53643b2dc61717bf913aae17edcc981213552ac3542/rchitect-0.6.0.tar.gz"
    sha256 "8620a3e91cdabdd4f19481502526e4aaa5c46cb63fca7229d07564a354692e6f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/cb/27/eeb9f307bf07060f3d9f9aa0fb8c15b01bdfded0a941e4b2719c7f94cacd/pycparser-3.12.tar.gz"
    sha256 "f03387877eab82ce01bbdfd0ba7252ee55a90b1c708d5129e2ce915475cf1db6"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/a3/a4/4692ecd7fa700ac1066b1c1f6cadef60aa2e01e5e364710235137d823e0a/jedi-0.20.1.tar.gz"
    sha256 "2f71208c3f9c1bca057c0e90d3f272aba44ace88fc4067d7587e9e069331b7e5"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/30/4b/90c937815137d43ce71ba043cd3566221e9df6b9c805f24b5d138c9d40a7/parso-0.8.7.tar.gz"
    sha256 "eaaac4c9fdd5e9e8852dc778d2d7405897ec510f2a298071453e5e3a07914bb1"
  end

  on_macos do
    on_arm do
      resource "lief" do
        url "https://files.pythonhosted.org/packages/da/b0/9f231000f0b1d0d227fa4b3a6a66aff4d5168dcc642c697605e0df739b4f/lief-1.0.0-cp312-abi3-macosx_11_0_arm64.whl"
        sha256 "92bf3b06c19a1ebd9e7978de47cc61040752ec452f7906bc3aac8d57abb23a8b"
      end
    end

    on_intel do
      resource "lief" do
        url "https://files.pythonhosted.org/packages/03/68/4eaec5e731fa53d764d60767037fccb4ca55d1f2cf1679edaa8ae0f3a07f/lief-1.0.0-cp312-abi3-macosx_11_0_x86_64.whl"
        sha256 "48e360eea660d019312e377954f327e4fe0918781ee45e9056cd641f50bb6355"
      end
    end
  end

  def install
    virtualenv_install_with_resources without: ["lief"]
    resources.each do |r|
      if r.name == "lief"
        r.stage do
          system Formula["python@3.15"].opt_bin/"python3.15", "-m", "pip",
            "--python=#{libexec}/bin/python",
            "install", "--no-deps", "--no-compile", "--ignore-installed",
            Pathname.pwd.children.find { |f| f.extname == ".whl" }.to_s
        end
      end
    end
  end

  test do
    system bin/"radian", "--version"
  end
end
