require "language/node"

class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://registry.npmjs.org/cortexso/-/cortexso-0.0.56.tgz"
  sha256 "32a411ede26128a525003139ecf948aac85e9e530c5262826a581d8511da7d2f"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    # @cpu-instructions bundles all binaries for other platforms & architectures
    # This deletes the non-matching architecture otherwise brew audit will complain.
    prebuilds = libexec/"lib/node_modules/cortexso/node_modules/cpu-instructions/prebuilds"
    (prebuilds/"darwin-x64").rmtree if OS.mac? && Hardware::CPU.arm?
    (prebuilds/"darwin-arm").rmtree if OS.mac? && Hardware::CPU.intel?
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    pid = fork { exec "#{bin}/cortex", "serve", "--port", port.to_s }
    sleep 5
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/v1/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
