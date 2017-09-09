module StringUtilities
  def sanitize_string_for_search(string)
    string.downcase.gsub(/[^0-9a-z ]/i, '')
  end

  def remove_parens(string)
    string.gsub(/\([^)]*\)/, '').rstrip
  end
end
