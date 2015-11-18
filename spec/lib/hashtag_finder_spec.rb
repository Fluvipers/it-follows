require "rails_helper"
require "hashtag_finder"
describe HashtagFinder do
  it "should return 'biblefight' when the texts 'the winner is @dave because he beat @goliath #biblefight' is given" do
    result = HashtagFinder.new('the winner is @dave because he beat @goliath #biblefight').find_hashtags
    expect(result).to eq ["biblefight"]
  end
end
