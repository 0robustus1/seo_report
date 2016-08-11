require "spec_helper"
require "pry"

describe SeoReport::Extractions::Head do
  let(:some_url) { "http://localhost/some-test-url/" }

  it { expect(described_class).to be_registered_with(:extract_head, for: :html) }

  describe "#extract_head" do
    subject { SeoReport::Report.new(some_url) }

    before do
      stub_request(:get, some_url).
        to_return(body: File.read("spec/fixtures/full-information.html"))
    end

    it "contains the title" do
      subject.produce
      request = subject.data[:requests].first
      expect(request[:title]).to eq("About")
    end
  end
end
