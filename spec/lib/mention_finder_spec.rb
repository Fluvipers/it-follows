require "rails_helper"
require "mention_finder"
describe MentionFinder do
  it "should return 'dave' and  'goliath' when the texts 'the winner is @dave because he beat @goliath #biblefight' is given" do
    result = MentionFinder.new('the winner is @dave because he beat @goliath #biblefight').find_mentions
    expect(result).to eq ["dave", "goliath"]
  end
end
