class Vtracer < Formula
  desc "Raster to vector graphics converter built on top of visioncortex"
  homepage "https://github.com/visioncortex/vtracer"
  url "https://github.com/visioncortex/vtracer/archive/refs/tags/0.6.4.zip"
  sha256 "20010bd11eb56a1f72e77da12c1fc03401533048747a3dd13b13f4e67e93d596"
  license "Copyright (c) 2024 TSANG, Hao Fung"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"vtracer", "completions")
    (share/"elvish/lib/rip.elv").write Utils.safe_popen_read(bin/"vtracer", "completions", "elvish")
    (share/"powershell/completions/_rip.ps1").write Utils.safe_popen_read(bin/"vtracer", "completions", "powershell")
    (share/"nu/completions/rip.nu").write Utils.safe_popen_read(bin/"vtracer", "completions", "nushell")
  end
end
