require "spec_helper"
require "pry"

describe SeoReport::Extractions::Opengraph do
  let(:some_url) { "http://localhost/some-test-url/" }

  it { expect(described_class).to be_registered_with(:extract_og, for: :html) }

  describe "#extract_og" do
    let(:og_type) { "website" }
    let(:og_title) { "Some Title for Opengraph" }
    let(:og_description) { "Some Description of Opengraph" }
    let(:og_site_name) { "Some Site" }
    let(:og_image) { "http://localhost/some-test-url/some.png" }
    let(:og_url) { some_url }

    let(:content) do
      {
        og_type: og_type,
        og_title: og_title,
        og_description: og_description,
        og_site_name: og_site_name,
        og_image: og_image,
        og_url: og_url,
      }
    end

    subject { SeoReport::Report.new(some_url) }

    before do
      stub_request(:get, some_url).
        to_return(body: render_template(content))
    end

    it "contains the opengraph information" do
      subject.produce
      request = subject.data[:requests].first
      opengraph = request[:og]
      expect(opengraph).to_not be_nil
      expect(opengraph[:type]).to eq(og_type)
      expect(opengraph[:title]).to eq(og_title)
      expect(opengraph[:description]).to eq(og_description)
      expect(opengraph[:site_name]).to eq(og_site_name)
      expect(opengraph[:image]).to eq(og_image)
      expect(opengraph[:url]).to eq(og_url)
    end

    context "without opengraph data" do
      let(:content) { {} }

      it "doesn't contain data" do
        subject.produce
        request = subject.data[:requests].first
        opengraph = request[:og]
        expect(opengraph).to_not be_nil
        expect(opengraph[:type]).to be_nil
        expect(opengraph[:title]).to be_nil
        expect(opengraph[:description]).to be_nil
        expect(opengraph[:site_name]).to be_nil
        expect(opengraph[:image]).to be_nil
        expect(opengraph[:url]).to be_nil
      end
    end

    context "with only the opengraph type" do
      let(:content) { {og_type: og_type} }

      it "only contains the type" do
        subject.produce
        request = subject.data[:requests].first
        opengraph = request[:og]
        expect(opengraph).to_not be_nil
        expect(opengraph[:type]).to eq(og_type)
        expect(opengraph[:title]).to be_nil
        expect(opengraph[:description]).to be_nil
        expect(opengraph[:site_name]).to be_nil
        expect(opengraph[:image]).to be_nil
        expect(opengraph[:url]).to be_nil
      end
    end

    context "with only the opengraph title" do
      let(:content) { {og_title: og_title} }

      it "only contains the title" do
        subject.produce
        request = subject.data[:requests].first
        opengraph = request[:og]
        expect(opengraph).to_not be_nil
        expect(opengraph[:type]).to be_nil
        expect(opengraph[:title]).to eq(og_title)
        expect(opengraph[:description]).to be_nil
        expect(opengraph[:site_name]).to be_nil
        expect(opengraph[:image]).to be_nil
        expect(opengraph[:url]).to be_nil
      end
    end

    context "with only the opengraph description" do
      let(:content) { {og_description: og_description} }

      it "only contains the description" do
        subject.produce
        request = subject.data[:requests].first
        opengraph = request[:og]
        expect(opengraph).to_not be_nil
        expect(opengraph[:type]).to be_nil
        expect(opengraph[:title]).to be_nil
        expect(opengraph[:description]).to eq(og_description)
        expect(opengraph[:site_name]).to be_nil
        expect(opengraph[:image]).to be_nil
        expect(opengraph[:url]).to be_nil
      end
    end

    context "with only the opengraph site_name" do
      let(:content) { {og_site_name: og_site_name} }

      it "only contains the site_name" do
        subject.produce
        request = subject.data[:requests].first
        opengraph = request[:og]
        expect(opengraph).to_not be_nil
        expect(opengraph[:type]).to be_nil
        expect(opengraph[:title]).to be_nil
        expect(opengraph[:description]).to be_nil
        expect(opengraph[:site_name]).to eq(og_site_name)
        expect(opengraph[:image]).to be_nil
        expect(opengraph[:url]).to be_nil
      end
    end

    context "with only the opengraph image" do
      let(:content) { {og_image: og_image} }

      it "only contains the image" do
        subject.produce
        request = subject.data[:requests].first
        opengraph = request[:og]
        expect(opengraph).to_not be_nil
        expect(opengraph[:type]).to be_nil
        expect(opengraph[:title]).to be_nil
        expect(opengraph[:description]).to be_nil
        expect(opengraph[:site_name]).to be_nil
        expect(opengraph[:image]).to eq(og_image)
        expect(opengraph[:url]).to be_nil
      end
    end

    context "with only the opengraph url" do
      let(:content) { {og_url: og_url} }

      it "only contains the url" do
        subject.produce
        request = subject.data[:requests].first
        opengraph = request[:og]
        expect(opengraph).to_not be_nil
        expect(opengraph[:type]).to be_nil
        expect(opengraph[:title]).to be_nil
        expect(opengraph[:description]).to be_nil
        expect(opengraph[:site_name]).to be_nil
        expect(opengraph[:image]).to be_nil
        expect(opengraph[:url]).to eq(og_url)
      end
    end
  end
end
