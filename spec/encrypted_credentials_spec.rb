require 'yaml'

require 'encrypted_credentials/coder'

RSpec.describe EncryptedCredentials::Coder do
  subject { EncryptedCredentials::Coder }

  it "generates non-empty key" do
    expect(subject.generate_key_hex).to_not be_empty
    expect(subject.generate_key_hex).to_not be_nil
  end

  it "decodes what it encoded" do
    source = 'test test test...'

    key = subject.generate_key_hex

    encoded = subject.encrypt(source, key)
    decoded = subject.decrypt(encoded, key)

    expect(decoded).to eq source
  end

  Dir[__dir__ + '/fixtures/rails_ciphertexts/*.enc'].each do |encrypted_file|
    base_name = File.basename(encrypted_file)
    rails_version = base_name.split('.')[0..-2].join('.')
    key_file = File.dirname(encrypted_file) + '/' + rails_version + '.key'
    data_file = File.dirname(encrypted_file) + '/' + rails_version
    
    it "decodes Rails-generated ciphertext (#{rails_version})" do
      data = File.binread(encrypted_file)
      key = File.binread(key_file)

      expect(subject.decrypt(data, key).strip).to eq File.read(data_file).strip
    end
  end
end
