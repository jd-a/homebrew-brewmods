class Hayagriva < Formula
  desc "Rusty bibliography management for Typst"
  homepage "https://github.com/typst/hayagriva"
  url "https://github.com/typst/hayagriva/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "41c82a16510cdceb922250e2f133227759c6ee1ff05bef5328598b97f7168edf"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    # Build and install the CLI (with bundled CSL style archive)
    system "cargo", "install",
           "--features", "cli,archive",
           *std_cargo_args
  end

  test do
    # Version check
    assert_match version.to_s, shell_output("#{bin}/hayagriva --version")

    # Minimal smoke test: show help for a subcommand
    output = shell_output("#{bin}/hayagriva help reference")
    assert_match "reference", output
  end
end
