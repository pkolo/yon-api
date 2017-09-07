require 'net/http'
require 'uri'

module SearchUtilities
  def sanitize_string_for_search(string)
    string.downcase.gsub(/[^0-9a-z ]/i, '')
  end
end

class ApiBase
  def get(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def parameterize(params_hash)
    new_params = params_hash.map do |param|
      "#{param[0].to_s}=#{param[1].to_s}"
    end

    new_params.join("&")
  end
end
