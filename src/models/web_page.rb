require 'net/http'

class WebPage
  def initialize(url)
    @uri = URI.parse(url)
  end

  def get
    @response = Net::HTTP.get_response(uri)
  end

  def uri
    @uri
  end

  def header
    @header ||= {
                  'User-Agent': 'hoge'
                }
  end

  def response
    @response
  end

  def code
    response.code
  end

end
