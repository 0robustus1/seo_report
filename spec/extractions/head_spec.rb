require "spec_helper"
require "pry"

describe SeoReport::Extractions::Head do
  let(:some_url) { "http://localhost/some-test-url/" }

  it { expect(described_class).to be_registered_with(:extract_head, for: :html) }

  describe "#extract_head" do
    let(:content) do
      {
        title: title,
        description: description,
      }
    end
    let(:title) { "About" }
    let(:description) { "About the test-page and the its author." }

    subject { SeoReport::Report.new(some_url) }

    before do
      stub_request(:get, some_url).
        to_return(body: render_template(content))
    end

    it "contains the title" do
      subject.produce
      request = subject.data[:requests].first
      expect(request[:title]).to eq(title)
    end

    it "contains the description" do
      subject.produce
      request = subject.data[:requests].first
      expect(request[:description]).to eq(description)
    end

    context "without title" do
      let(:title) { nil }

      it "still contains the rest" do
        subject.produce
        request = subject.data[:requests].first
        expect(request[:title]).to be_nil
        expect(request[:description]).to eq(description)
      end
    end

    context "without description" do
      let(:description) { nil }

      it "still contains the rest" do
        subject.produce
        request = subject.data[:requests].first
        expect(request[:title]).to eq(title)
        expect(request[:description]).to be_nil
      end
    end
  end
end
