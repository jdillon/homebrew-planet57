# Homebrew formula for Forge
# Install: brew tap jdillon/planet57 && brew install forge

class Forge < Formula
  desc "Modern CLI framework for deployments"
  homepage "https://github.com/jdillon/forge"
  url "https://github.com/jdillon/forge/releases/download/v0.1.1/planet57-forge-0.1.1.tgz"
  sha256 "cca857e82659ec5f0b90450e94e7fc14a040bac54e8daa597ea06c70dbb1172a"
  license "Apache-2.0"
  version "0.1.1"

  depends_on "oven-sh/bun/bun"

  def install
    # Install package to libexec
    libexec.install Dir["*"]

    # Install dependencies
    cd libexec do
      system "bun", "install", "--production"
    end

    # Create wrapper script that runs forge from libexec
    (bin/"forge").write <<~SH
      #!/bin/bash
      exec "#{Formula["bun"].opt_bin}/bun" run "#{libexec}/bin/forge" "$@"
    SH
  end

  test do
    assert_match "forge", shell_output("#{bin}/forge --help")
  end
end
