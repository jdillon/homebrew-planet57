# Homebrew formula for Forge
# Install: brew tap jdillon/planet57 && brew install forge

class Forge < Formula
  desc "Modern CLI framework for deployments"
  homepage "https://github.com/jdillon/forge"
  url "https://github.com/jdillon/forge/releases/download/v0.1.2/planet57-forge-0.1.2.tgz"
  sha256 "6e3cf028e52e9ba8d885f09407eaf39e7bd1f2c6c150ee76d6f2b5e387c2db8b"
  license "Apache-2.0"
  version "0.1.2"

  depends_on "oven-sh/bun/bun"

  def install
    # Stage package to libexec
    libexec.install Dir["*"]

    # Symlink the wrapper script
    # First run will auto-bootstrap ~/.forge
    bin.install_symlink libexec/"bin/forge" => "forge"
  end

  def caveats
    "First run will complete installation to ~/.forge\n\n" \
    "User data (config, plugins, state) persists across upgrades.\n" \
    "To fully remove, also delete ~/.forge after uninstall.\n"
  end

  test do
    # Just verify the wrapper exists and is executable
    assert_predicate bin/"forge", :executable?
  end
end
