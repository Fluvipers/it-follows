class MentionFinder 
  def initialize(sentence)
    @sentence = sentence
  end
  def find_mentions
    @sentence.split.select { |t| t.start_with? '@'}.map {|f| f[1..-1]}
  end
end
