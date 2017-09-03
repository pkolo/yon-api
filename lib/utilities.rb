module SearchUtilities
  def sanitize_string_for_search(string)
    string.downcase.gsub(/[^0-9a-z ]/i, '')
  end
end
