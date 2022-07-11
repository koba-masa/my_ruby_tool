require './src/models/result/tsv'

module GTM
  class Common
    def initialize(parsed_data, url_format)
      @parsed_data = parsed_data.dig(key)
      @url_format = url_format
      @contents = []
    end

    def parse
    end

    def output(file_name)
      Result::Tsv.new("#{file_name}_#{key}.tsv", header, contents, nil).output
    end

    def parsed_data
      @parsed_data
    end

    def contents
      @contents
    end

    def url(id)
      @url_format % [ "#{key}s", id ]
    end
  end
end
