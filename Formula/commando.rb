# Homebrew formula for Commando
# Install: brew tap jdillon/planet57 && brew install commando

class Commando < Formula
  desc "Modern CLI framework for deployments"
  homepage "https://github.com/jdillon/commando"
  url "https://github.com/jdillon/commando/releases/download/v0.2.0/planet57-commando-0.2.0.tgz"
  sha256 "b58f8a4b226c0f604ebbbbd4a9d8c4e99e46bd44a9a092f5ca93ea6d900e7e0b"
  license "Apache-2.0"
  version "0.2.0"

  depends_on "oven-sh/bun/bun"

  def install
    # Stage package to libexec
    libexec.install Dir["*"]

    # Symlink the wrapper script
    # First run will auto-bootstrap ~/.commando
    bin.install_symlink libexec/"bin/cmdo" => "cmdo"
  end

  def caveats
    "First run will complete installation to ~/.commando\n\n" \
    "User data (config, plugins, state) persists across upgrades.\n" \
    "To fully remove, also delete ~/.commando after uninstall.\n"
  end

  test do
    # Just verify the wrapper exists and is executable
    assert_predicate bin/"cmdo", :executable?
  end
end
