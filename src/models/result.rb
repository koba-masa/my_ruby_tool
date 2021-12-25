require 'csv'

class Result
  def initialize(output_file)
    @output_file = output_file
  end

  def append(content)
    contents.append(content)
  end

  def contents
    @contents ||= []
  end

  def output
    CSV.open(@output_file, "wb") do |csv|
      contents.each do | content |
        csv << content
      end
    end
  end
end