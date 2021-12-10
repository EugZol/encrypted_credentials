# frozen_string_literal: true

require_relative "lib/encrypted_credentials/version"

Gem::Specification.new do |spec|
  spec.name          = "encrypted_credentials"
  spec.version       = EncryptedCredentials::VERSION
  spec.authors       = ["Eugene Zolotarev", "Hodlex Ltd."]
  spec.email         = ["eugzol@gmail.com", "cto@hodlhodl.com"]

  spec.summary       = "Light weight credentials encoder/decoder, compatible with Rails Credentials"
  spec.homepage      = "https://github.com/EugZol/enrypted_credentials"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
