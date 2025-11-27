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
    forge_home = ENV["FORGE_HOME"] || "#{Dir.home}/.forge"

    system "mkdir", "-p", "#{forge_home}/config", "#{forge_home}/state", "#{forge_home}/cache", "#{forge_home}/logs"

    File.write("#{forge_home}/package.json", <<~JSON)
      {
        "name": "forge-meta",
        "version": "1.0.0",
        "private": true
      }
    JSON

    File.write("#{forge_home}/bunfig.toml", <<~TOML)
      [install]
      exact = true
      dev = false
      peer = true
      optional = false
      auto = "disable"
    TOML

    cd forge_home do
      system "bun", "add", "file://#{buildpath}/package"
    end

    forge_cli = "#{forge_home}/node_modules/@planet57/forge/bin/forge"
    unless File.exist?(forge_cli)
      odie "Installation failed: forge CLI not found"
    end

    bin.install_symlink forge_cli
  end

  def caveats
    <<~EOS
      Forge installed to #{ENV["FORGE_HOME"] || "~/.forge"}
    EOS
  end

  test do
    assert_match "forge", shell_output("#{bin}/forge --help")
  end
end
