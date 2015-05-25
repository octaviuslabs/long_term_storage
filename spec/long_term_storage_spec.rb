require_relative '../lib/long_term_storage'


describe LongTermStorage do
  let(:correctly_initialized) { LongTermStorage::LongTermStorage.new bucket_name: 'vesper-lts-development' } # 'bucket_name' }
  let(:incorrectly_initialized) { LongTermStorage::LongTermStorage.new }
  let(:test_url) { 'https://s3.amazonaws.com/vesper-lts-development/wawa' }
  let(:test_url_bucket_dns) { 'https://vesper-lts-development.s3.amazonaws.com/wawa' }
  let(:public_url_to_object) { LongTermStorage::LongTermStorage.send(:public, :url_to_object) }

  it "should respond to store" do
    expect(correctly_initialized).to respond_to(:store)
  end

  it "should respond to retrieve" do
    expect(correctly_initialized).to respond_to(:retrieve)
  end

  it "should require a path argument for store" do
    expect{correctly_initialized.store contents: 'test'}.to raise_error
  end

  it "should require a contents argument for store" do
    expect{correctly_initialized.store path: 'test'}.to raise_error
  end

  it "should retrieve given a URL" do
    expect(correctly_initialized.retrieve url: test_url).to eq('')
  end

  it "should retrieve given a bucket and key" do
    expect(correctly_initialized.retrieve bucket_name: 'bucket', key: 'key').to eq('')
  end

  it "should parse bucket/key from dns" do
    public_url_to_object
    expect(correctly_initialized.url_to_object test_url_bucket_dns)
      .to eq(['vesper-lts-development','wawa'])
  end

  it "should parse bucket/key from path" do
    public_url_to_object
    expect(correctly_initialized.url_to_object test_url)
      .to eq(['vesper-lts-development','wawa'])
  end
end
