require './src/models/gtm/common'

#https://developers.google.com/tag-platform/tag-manager/api/v2/reference/accounts/containers/workspaces/get
module GTM
  class Html < Common
    KEY = 'tag_html'
    HEADER = %w[ID 名前 停止 タイプ 配信トリガーID フォルダーID URL]

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
