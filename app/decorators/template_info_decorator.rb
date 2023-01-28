# frozen_string_literal: true

# Декоратор для template_infos
class TemplateInfoDecorator < Draper::Decorator
  delegate_all

  OUTPUT_FORMAT_TO_TEMPLATE_EXT = { pdf: 'html', xls: 'xls' }.freeze

  def template_file_name
    file_ext = OUTPUT_FORMAT_TO_TEMPLATE_EXT[object.output_format] || 'txt'
    "template.#{file_ext}"
  end
end
