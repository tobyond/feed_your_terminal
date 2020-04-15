RSpec.describe FeedMethods do
  let(:fm) { described_class.new }
  let(:link1) { "https://link.com" }
  let(:link2) { "https://link2.com" }
  let(:link_array) { [link1, link2] }
  let(:array_of_link_objects) { [double(link: link1), double(link: link2)] }

  describe "#urls" do
    subject { fm.urls }

    it "is expected to call all_links on the Db" do
      expect(Db).to receive(:all_links)
      subject
    end
  end

  describe "#feed" do
    subject { fm.feed }
    let(:rss_double) { double }
    let(:channel_double) { double(items: ["result"]) }
    let(:urls) { ["url"] }

    context "when feed is valid" do
      it "is expected to generate the feed" do
        expect(fm).to receive(:urls) { urls }
        expect(RSS::Parser).to receive(:parse)
          .with("url")
          .and_return(rss_double)
        expect(fm).to receive(:invalid_feed?)
          .with(rss_double)
          .and_return(false)
        expect(rss_double).to receive(:channel) { channel_double }
        expect(subject).to eq(["result"])
      end
    end

    context "when feed is invalid" do
      it "is expected to be empty" do
        expect(fm).to receive(:urls) { urls }
        expect(RSS::Parser).to receive(:parse)
          .with("url")
          .and_return(rss_double)
        expect(fm).to receive(:invalid_feed?)
          .with(rss_double)
          .and_return(true)
        expect(subject).to be_empty
      end
    end
  end

  describe "#invalid_feed?" do
    subject { fm.invalid_feed?(item) }
    let(:item) { nil }

    context "when item is nil" do
      it { is_expected.to be(true) }
    end

    context "when item doesn't respond to channel" do
      let(:item) { double }

      it { is_expected.to be(true) }
    end

    context "when item responds to channel but is nil" do
      let(:item) { double(channel: nil) }

      it { is_expected.to be(true) }
    end

    context "when item responds to channel and has items but is nil" do
      let(:item) { double(channel: double(items: nil)) }

      it { is_expected.to be(true) }
    end

    context "when item responds to channel and has items but is empty" do
      let(:item) { double(channel: double(items: [])) }

      it { is_expected.to be(true) }
    end

    context "when item responds to channel and has items but is array" do
      let(:item) { double(channel: double(items: ["stuff"])) }

      it { is_expected.to be(false) }
    end
  end

  describe "#links" do
    subject { fm.links }

    it "is expected to return an array of links" do
      expect(fm).to receive(:feed) { array_of_link_objects }
      expect(subject).to eq(link_array)
    end
  end

  describe "#not_read" do
    subject { fm.not_read }

    it "is expected to filter out read links" do
      expect(fm).to receive(:links) { link_array }
      expect(Db).to receive(:seed_feed)
        .with(link_array)
      expect(fm).to receive(:read_links).twice { link_array }
      expect(fm).to receive(:feed) { array_of_link_objects }
      expect(subject).to be_empty
    end
  end

  describe "#read_links" do
    subject { fm.read_links }

    it "is expected to call read_link_array on the Db" do
      expect(Db).to receive(:read_link_array)
      subject
    end
  end
end
