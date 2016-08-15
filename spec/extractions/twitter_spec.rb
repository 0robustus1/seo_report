require "spec_helper"
require "pry"

describe SeoReport::Extractions::Twitter do
  let(:some_url) { "http://localhost/some-test-url/" }

  it { expect(described_class).to be_registered_with(:extract_twitter, for: :html) }

  describe "#extract_twitter" do
    let(:twitter_card) { "summary" }
    let(:twitter_domain) { some_url }
    let(:twitter_title) { "Some Title for Twitter" }
    let(:twitter_description) { "Some Description of Twitter" }

    let(:content) do
      {
        twitter_card: twitter_card,
        twitter_domain: twitter_domain,
        twitter_title: twitter_title,
        twitter_description: twitter_description,
      }
    end

    subject { SeoReport::Report.new(some_url) }

    before do
      stub_request(:get, some_url).
        to_return(body: render_template(content))
    end

    it "contains the twitter information" do
      subject.produce
      request = subject.data[:requests].first
      twitter = request[:twitter]
      expect(twitter).to_not be_nil
      expect(twitter[:card]).to eq(twitter_card)
      expect(twitter[:domain]).to eq(twitter_domain)
      expect(twitter[:title]).to eq(twitter_title)
      expect(twitter[:description]).to eq(twitter_description)
    end

    context "without twitter data" do
      let(:content) { {} }

      it "doesn't contain data" do
        subject.produce
        request = subject.data[:requests].first
        twitter = request[:twitter]
        expect(twitter).to_not be_nil
        expect(twitter[:card]).to be_nil
        expect(twitter[:domain]).to be_nil
        expect(twitter[:title]).to be_nil
        expect(twitter[:description]).to be_nil
      end
    end

    context "with only the twitter card" do
      let(:content) { {twitter_card: twitter_card} }

      it "only contains the card" do
        subject.produce
        request = subject.data[:requests].first
        twitter = request[:twitter]
        expect(twitter).to_not be_nil
        expect(twitter[:card]).to eq(twitter_card)
        expect(twitter[:domain]).to be_nil
        expect(twitter[:title]).to be_nil
        expect(twitter[:description]).to be_nil
      end
    end

    context "with only the twitter domain" do
      let(:content) { {twitter_domain: twitter_domain} }

      it "only contains the domain" do
        subject.produce
        request = subject.data[:requests].first
        twitter = request[:twitter]
        expect(twitter).to_not be_nil
        expect(twitter[:card]).to be_nil
        expect(twitter[:domain]).to eq(twitter_domain)
        expect(twitter[:title]).to be_nil
        expect(twitter[:description]).to be_nil
      end
    end

    context "with only the twitter title" do
      let(:content) { {twitter_title: twitter_title} }

      it "only contains the title" do
        subject.produce
        request = subject.data[:requests].first
        twitter = request[:twitter]
        expect(twitter).to_not be_nil
        expect(twitter[:card]).to be_nil
        expect(twitter[:domain]).to be_nil
        expect(twitter[:title]).to eq(twitter_title)
        expect(twitter[:description]).to be_nil
      end
    end

    context "with only the twitter description" do
      let(:content) { {twitter_description: twitter_description} }

      it "only contains the description" do
        subject.produce
        request = subject.data[:requests].first
        twitter = request[:twitter]
        expect(twitter).to_not be_nil
        expect(twitter[:card]).to be_nil
        expect(twitter[:domain]).to be_nil
        expect(twitter[:title]).to be_nil
        expect(twitter[:description]).to eq(twitter_description)
      end
    end
  end
end
