require './src/models/gtm/common'

module GTM
  class Folder < Common
    KEY = 'folder'
    HEADER = %w[]

    def parse
    end

    def key
      KEY
    end

    def header
      HEADER.join("\t")
    end

  end
end
