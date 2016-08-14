require "spec_helper"
require "pry"

describe SeoReport::Extractions::Seo do
  let(:some_url) { "http://localhost/some-test-url/" }

  it { expect(described_class).to be_registered_with(:extract_robots, for: :html) }
  it { expect(described_class).to be_registered_with(:extract_canonical, for: :html) }

  describe "#extract_robots" do
    let(:robots) { ["noindex,follow"] }

    let(:content) do
      {
        robots: robots
      }
    end

    subject { SeoReport::Report.new(some_url) }

    before do
      stub_request(:get, some_url).
        to_return(body: render_template(content))
    end

    it "contains the robots information" do
      subject.produce
      request = subject.data[:requests].first
      expect(request[:robots]).to eq(robots)
    end

    context "when there are multiple robots tags" do
      let(:robots) { %w(noindex,follow noarchive noodp) }

      it "provides them grouped together in a list" do
        subject.produce
        request = subject.data[:requests].first
        expect(request[:robots]).to eq(robots)
      end
    end

    context "without robots" do
      let(:robots) { nil }

      it "provides an empty list" do
        subject.produce
        request = subject.data[:requests].first
        expect(request[:robots]).to eq([])
      end
    end
  end

  describe "#extract_canonical" do
    let(:canonical) { some_url }

    let(:content) do
      {
        canonical: canonical
      }
    end

    subject { SeoReport::Report.new(some_url) }

    before do
      stub_request(:get, some_url).
        to_return(body: render_template(content))
    end

    it "contains the canonical" do
      subject.produce
      request = subject.data[:requests].first
      expect(request[:canonical]).to eq(canonical)
    end

    context "when there is no canonical" do
      let(:canonical) { nil }

      it "provides no canonical information" do
        subject.produce
        request = subject.data[:requests].first
        expect(request[:canonical]).to be_nil
      end
    end
  end
end
