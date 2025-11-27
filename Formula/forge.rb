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
    # Stage package to libexec for Homebrew tracking
    # Actual installation happens in post_install
    libexec.install Dir["*"]
  end

  def post_install
    forge_home = ENV["FORGE_HOME"] || "#{Dir.home}/.forge"

    # Create directory structure
    system "mkdir", "-p",
      "#{forge_home}/config",
      "#{forge_home}/state",
      "#{forge_home}/cache",
      "#{forge_home}/logs"

    # Write package.json (meta-project)
    File.write("#{forge_home}/package.json", <<~JSON)
      {
        "name": "forge-meta",
        "version": "1.0.0",
        "private": true
      }
    JSON

    # Write bunfig.toml
    File.write("#{forge_home}/bunfig.toml", <<~TOML)
      [install]
      exact = true
      dev = false
      peer = true
      optional = false
      auto = "disable"
    TOML

    # Install package to forge_home using bun
    Dir.chdir(forge_home) do
      system Formula["bun"].opt_bin/"bun", "add", "file://#{libexec}"
    end

    # Verify installation
    forge_bin = "#{forge_home}/node_modules/@planet57/forge/bin/forge"
    unless File.exist?(forge_bin)
      odie "Installation failed: forge CLI not found at #{forge_bin}"
    end

    # Symlink the wrapper script
    bin.install_symlink forge_bin => "forge"
  end

  def caveats
    <<~EOS
      Forge installed to #{ENV["FORGE_HOME"] || "~/.forge"}

      User data (config, plugins, state) persists across upgrades.
    EOS
  end

  test do
    assert_match "forge", shell_output("#{bin}/forge --help")
  end
end
