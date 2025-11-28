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
    # Stage package to libexec
    libexec.install Dir["*"]

    # Symlink the wrapper script
    # First run will auto-bootstrap ~/.forge
    bin.install_symlink libexec/"bin/forge" => "forge"
  end

  def caveats
    <<~EOS
      First run will complete installation to ~/.forge

      User data (config, plugins, state) persists across upgrades.
      To fully remove, also delete ~/.forge after uninstall.
    EOS
  end

  test do
    # Just verify the wrapper exists and is executable
    assert_predicate bin/"forge", :executable?
  end
end
