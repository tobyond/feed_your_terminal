RSpec.describe Presenters::RubyPresenter do
  describe ".present" do
    subject { described_class.present(feed) }
    let(:feed) { nil }

    context "when feed isn't an array" do
      it { is_expected.to be_nil }
    end

    context "when feed is array with incorrect elements" do
      let(:feed) { [double({title: "this is the title", loonk: "the/link" })] }

      it "is expected to raise IncorrectRSSFormatError" do
        expect { subject }.to raise_error(FeedYourTerminal::IncorrectRSSFormatError)
      end
    end
  end
end
