# frozen_string_literal: true

require 'uri'

# Доступ к функциям data_to_Document сервиса.
# В данном случае нужна только функция documents/{:template_name}/tags
class HttpService
  include ActiveModel::Validations

  TAGS_ENTRY_POINT = 'tags'
  HEALTH_CHECK_POINT = 'barcode_to_image'
  DOCUMENTS_PATH = 'api/documents'
  API_PATH = 'api'

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

  def report!(template_name)
    template_info = TemplateInfo.by_name(template_name).first
    raise NotFoundError, "Could not find template with name #{template_name}" unless template_info

    response = faraday_post(template_info)
    JSON.parse(response.body)['pdf_base64']
  rescue StandardError => e
    raise Error, e.message
  end

  def health_check!
    target_url = make_url(@data_to_document_url, API_PATH, HEALTH_CHECK_POINT, '1234567890').to_s
    response = Faraday.get(target_url)
    raise Error, response.body unless response.status == 200

    true
  end

  protected

  def make_url(*args)
    parts = args.map { |part| part.end_with?('/') ? part[0..-2] : part }
    parts.join('/')
  end

  def faraday_post(template_info)
    target_url = make_url(@data_to_document_url, DOCUMENTS_PATH, template_info.name).to_s
    response = Faraday.post(target_url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['accept'] = 'text/plain'
      req.body = TagsDecorator.decorate(template_info.tags).as_template_params_json.to_json
    end
    raise Error, response.body unless response.status == 200

    response
  end
end

