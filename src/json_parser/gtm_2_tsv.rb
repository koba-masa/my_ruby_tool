require "json"
require './src/models/gtm'

class Gtm2Tsv

  def initialize(file, workspace_id)
    @file_path = file
    @workspace_id = workspace_id
    gtm
  end

  def execute
    output_file_name = gtm.output_file_name

    gtm.tag.parse
    gtm.tag.output(output_file_name)
    gtm.trigger.parse
    gtm.trigger.output(output_file_name)
  end

  def gtm
    @gtm ||= Gtm.new(@file_path, @workspace_id)
  end

  def type_to(type)
    case(type)
    when 'gclidw'
      'コンバージョンリンカー'
    when 'cvt_1703960_463'
      'Yahoo広告 サイトジェネラルタグ'
    when 'ua'
      'ユニバーサル アナリティクス'
    when 'html'
      'カスタムHTML'
    else
      type
    end
  end


end

if ARGV.size == 1
  workspace_id = '<workspace_id>'
elsif ARGV.size == 2
  workspace_id = ARGV[1]
else
  puts '[ERROR] 引数の数が間違っています。'
  exit
end

gtm_file = ARGV[0]

Gtm2Tsv.new(gtm_file, workspace_id).execute
