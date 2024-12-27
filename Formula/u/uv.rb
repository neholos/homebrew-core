class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.5.13.tar.gz"
  sha256 "4d856b06e4e7d852b273fbc1763b7a05609a436b355a7e99b8f39cf84f157d69"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "842f6d0812e3f2a3ade781cad762d12ed02e3cc1d61c0e3ee211e0f74ab53b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ced1e954c3a9367af27d3eefd2da5c96734eec9bb9d59d507b8973da12aaa60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cb79bff616f96a2c41d2c13f6813fa6c559dd3b43abbd8e45a60b414d562e7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbe2eb8c1da7c3d88098bb3b59ba04b5b965aef5fac5de513e528bbff915ce3b"
    sha256 cellar: :any_skip_relocation, ventura:       "23086017071dbef07df660b87e3a85cbe7cf2941a94b81bd529f691cfbdbb9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "459b33504e137bb1fc0d761384b1537c183735b257063f609d0699400bdd7697"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion", base_name: "uvx")
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
