require './src/models/gtm/common'

#https://developers.google.com/tag-platform/tag-manager/api/v2/reference/accounts/containers/workspaces/get
module GTM
  class Tag < Common
    KEY = 'tag'
    HEADER = %w[ID 名前 停止 タイプ 配信トリガーID フォルダーID URL]
    HEADER_HTML = %w[ID 名前 URL HTML]

    def parse
      parsed_data.each do | data |
        id = data.dig('tagId')
        name = data.dig('name')
        paused = data.dig('paused') ? '停止中' : '稼働中'
        type = type_to(data.dig('type'))
        trigger_ids = data.dig('firingTriggerId')
        trigger_ids = trigger_ids.nil? ? [''] : trigger_ids
        folder_id = data.dig('parentFolderId')
        formatted_url = url(id)

        parse_html(id, name, data.dig('parameter'), formatted_url) if type == 'html'

        trigger_ids.each_with_index do | trigger_id, index |
          contents.append(
            [
              id,
              name,
              paused,
              type,
              trigger_id,
              folder_id,
              index.zero? ? formatted_url : nil,
            ].map! { | item | item.nil? ? '' : item }
          )
        end
      end
    end

    def output(file_name)
      super
      Result::Tsv.new(
        "#{file_name}_#{key}_html.tsv",
        HEADER_HTML.join("\t"),
        html_contents,
        nil
      ).output
    end

    def parse_html(id, name, parameters, url)
      parameters.each do | parameter |
        html_contents.append(
          [
            id,
            name,
            url,
            parameter.dig('value').gsub(/\n/, '').gsub(/\t/, '')
          ].map! { | item | item.nil? ? '' : item }
        ) if parameter.dig('key') == 'html'
      end
    end

    def html_contents
      @html_contents ||= []
    end

    def type_to(type)
      type
    end

    def key
      KEY
    end

    def header
      HEADER.join("\t")
    end
  end
end
