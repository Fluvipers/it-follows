class HashtagFinder 
  def initialize(sentence)
    @sentence = sentence
  end
  def find_hashtags
    @sentence.split.select { |t| t.start_with? '#'}.map {|f| f[1..-1]}
  end
end
