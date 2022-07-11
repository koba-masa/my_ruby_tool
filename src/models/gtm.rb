require './src/models/result/tsv'
require './src/models/gtm/tag'
require './src/models/gtm/trigger'
require './src/models/gtm/folder'


class Gtm
  CONTAINER_VERSION = 'containerVersion'
  CONTAINER = 'container'
  EXPORT_TIME = 'exportTime'

  def initialize(json_file_path, workspace_id_)
    @file_path = File.expand_path(json_file_path, Dir.pwd)
    unless File.exist?(file_path) || File.file?(file_path)
      raise StandardError("File is not found. : #{file_path}")
    end
    @workspace_id = workspace_id_
    #@folder = GTM::Folder.new(parsed_data.dig(CONTAINER_VERSION), url)
    #@variable = GTM::Variable.new(parsed_data.dig(CONTAINER_VERSION), url)
    #@built_in_variable = .new(parsed_data.dig(CONTAINER_VERSION), url)
  end

  def output_file_name
    return @output_file_name unless @output_file_name.nil?

    container_name = parsed_data.dig(CONTAINER_VERSION, CONTAINER, 'name')
    gtm_id = parsed_data.dig(CONTAINER_VERSION, CONTAINER, 'publicId')
    version_id = parsed_data.dig(CONTAINER_VERSION, 'containerVersionId')
    #@output_file_name = "#{container_name}_#{gtm_id}_#{version_id}/#{container_name}_#{gtm_id}_#{version_id}"
    @output_file_name = "#{container_name}_#{gtm_id}_#{version_id}"
  end

  def parsed_data
    @parsed_data ||= parse
  end

  def tag
    @tag ||= GTM::Tag.new(parsed_data.dig(CONTAINER_VERSION), url)
  end

  def trigger
    @trigger ||= GTM::Trigger.new(parsed_data.dig(CONTAINER_VERSION), url)
  end

  def variable
    @variable
  end

  def folder
    @folder
  end

  def parse
    File.open(file_path, mode = "r") do | json |
      JSON.parse(json.read)
    end
  end

  def file_path
    @file_path
  end

  def url
    @url ||= "https://tagmanager.google.com/?authuser=1#/container/" \
      << "accounts/#{account_id}/" \
      << "containers/#{container_id}/" \
      << "workspaces/#{workspace_id}/" \
      << "%s/%s"
  end

  def account_id
    @account_id ||= parsed_data.dig(CONTAINER_VERSION, CONTAINER, 'accountId')
  end

  def container_id
    @container_id ||= parsed_data.dig(CONTAINER_VERSION, CONTAINER, 'containerId')
  end

  def workspace_id
    @workspace_id
  end
end

