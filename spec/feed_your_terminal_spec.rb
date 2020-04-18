RSpec.describe FeedYourTerminal do
  it "has a version number" do
    expect(FeedYourTerminal::VERSION).not_to be nil
  end

  describe "String#snake" do
    subject { string.snake }

    context "when simple sentence of mixed case" do
      let(:string) { "Here are some Words" }

      it { is_expected.to eq("here_are_some_words") }
    end

    context "when simple sentence of mixed case and punctuation" do
      let(:string) { "Here, are some Words!:" }

      it { is_expected.to eq("here_are_some_words") }
    end

    context "when simple sentence of mixed case and punctuation and numbers" do
      let(:string) { "Here, are some numbers!: 10%, #20, $1000" }

      it { is_expected.to eq("here_are_some_numbers_10_20_1000") }
    end
  end
end
