require './src/models/gtm/common'

module GTM
  class Trigger < Common
    KEY = 'trigger'
    #HEADER = %w[ID, 名前, タイプ, フォルダID, フィルタ種別, フィルタ]
    HEADER = %w[ID 名前 タイプ フォルダID URL フィルター種別 条件種別 条件]

    def parse
      parsed_data.each do | data |
        id = data.dig('triggerId')
        name = data.dig('name')
        type = data.dig('type')
        folder_id = data.dig('parentFolderId')
        formatted_url = url(id)

        filters(data).each.with_index do | (filter_type, filter_contents), index |
          filter_contents.each do | filter_content |
            contents.append(
              [
                id,
                name,
                type,
                folder_id,
                index.zero? ? formatted_url : nil,
                filter_type,
                filter_content[:type],
                filter_content[:value],
              ].map! { | item | item.nil? ? '' : item }
            )
          end
        end
      end
    end

    def filters(data)
      {
        normal_filter: normal_filter(data),
        auto_event_filter: auto_event_filter(data),
        custom_event_filter: custom_event_filter(data),
      }
    end

    def normal_filter(data)
      filters = data.dig('filter')
      return [] if filters.nil?
      filters.map do | filter |
        {
          type: filter.dig('type'),
          value: filter.dig('parameter').map { | param | param.dig('value') }.join(',')
        }
      end
    end

    def auto_event_filter(data)
      filters = data.dig('autoEventFilter')
      return [] if filters.nil?
      filters.map do | filter |
        {
          type: filter.dig('type'),
          value: filter.dig('parameter').map { | param | param.dig('value') }.join(',')
        }
      end
    end

    def custom_event_filter(data)
      filters = data.dig('customEventFilter')
      return [] if filters.nil?
      filters.map do | filter |
        {
          type: filter.dig('type'),
          value: filter.dig('parameter').map { | param | param.dig('value') }.join(',')
        }
      end
    end

    def key
      KEY
    end

    def header
      HEADER.join("\t")
    end

  end
end
