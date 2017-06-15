class TextService

  def self.find_keywords(input, source_relation)
    input = input.downcase

    keywords = []
    keywords_by_id = {}

    # tokenize input
    words = input.split((/[^A-Za-z0-9_+]+/))

    words.each_with_index do |word, index|
      #next if word.length == 2
      results = source_relation.search_by_exact_name(word)
      # add to keywords if matching word
      self.add_to_list_hash(results.first, keywords, keywords_by_id)

      if index > 0
        # get 2 word keywords
        phrase =  "#{words[index-1]} #{word}"
        # add to keywords if matching
        results = source_relation.search_by_exact_name(phrase)
        self.add_to_list_hash(results.first, keywords, keywords_by_id)
      end

      if index > 1
        # get 3 word keywords
        phrase =  "#{words[index-2]} #{words[index-1]} #{word}"
        # add to keywords if matching
        results = source_relation.search_by_exact_name(phrase)
        self.add_to_list_hash(results.first, keywords, keywords_by_id)
      end
    end
    return keywords
  end

  def self.add_to_list_hash(obj, list, hash)
    return if obj.nil? || hash[obj.id]
    list << obj
    hash[obj.id] = true
  end
end