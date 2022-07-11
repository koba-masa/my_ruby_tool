module Result
  class Tsv
    def initialize(file_path, header, contents, footer)
      @output_file_path = File.expand_path("tmp/results/#{file_path}", Dir.pwd)
      @header = header
      @contents = contents
      @footer = footer
    end

    def output
      File.open(@output_file_path, mode = "w") do | tsv |
        tsv.write(@header, "\n") unless @header.nil? || @header.empty?
        @contents.each do | row |
          tsv.write("#{row.join("\t")}", "\n")
        end
        tsv.write(@footer, "\n") unless @footer.nil? || @footer.empty?
      end
    end
  end
end
