# Homebrew formula for Commando
# Install: brew tap jdillon/planet57 && brew install commando

class Commando < Formula
  desc "Modern CLI framework for deployments"
  homepage "https://github.com/jdillon/commando"
  url "https://github.com/jdillon/commando/releases/download/v0.1.3/planet57-commando-0.1.3.tgz"
  sha256 "PLACEHOLDER"
  license "Apache-2.0"
  version "0.1.3"

  depends_on "oven-sh/bun/bun"

  def install
    # Stage package to libexec
    libexec.install Dir["*"]

    # Symlink the wrapper script
    # First run will auto-bootstrap ~/.commando
    bin.install_symlink libexec/"bin/cmdo" => "cmdo"
  end

  def caveats
    <<~EOS
      First run will complete installation to ~/.commando

      User data (config, plugins, state) persists across upgrades.
      To fully remove, also delete ~/.commando after uninstall.
    EOS
  end

  test do
    # Just verify the wrapper exists and is executable
    assert_predicate bin/"cmdo", :executable?
  end
end
