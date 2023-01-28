# frozen_string_literal: true

require 'uri'

# Доступ к функциям data_to_Document сервиса.
# В данном случае нужна только функция documents/{:template_name}/tags
class HttpService
  include ActiveModel::Validations

  TAGS_ENTRY_POINT = 'tags'
  DOCUMENTS_PATH = 'api/documents'

  class NotFoundError < StandardError; end
  class Error < StandardError; end

  attr_accessor :data_to_document_url

  def initialize
    @data_to_document_url = Rails.configuration.x.data_to_document_url
  end

  def tags!(template_name)
    target_url = make_url(@data_to_document_url, DOCUMENTS_PATH, template_name, TAGS_ENTRY_POINT).to_s
    response = Faraday.get(target_url)
    raise NotFoundError, "Could not find template with name #{template_name}" if response.status == 404

    raise Error, response.body unless response.status == 200

    JSON.parse(response.body)['tag_list']
  rescue StandardError => e
    raise Error, e.message
  end

  protected

  def make_url(*args)
    parts = args.map { |part| part.end_with?('/') ? part[0..-2] : part }
    parts.join('/')
  end
end

