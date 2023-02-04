# frozen_string_literal: true

# Декоратор для template_infos
class TemplateInfoDecorator < Draper::Decorator
  delegate_all

  OUTPUT_FORMAT_TO_TEMPLATE_EXT = { pdf: 'html', xls: 'xls' }.freeze

  def template_file_name
    return object.template.original_file_name unless object.template&.original_file_name.blank?

    file_ext = OUTPUT_FORMAT_TO_TEMPLATE_EXT[object.output_format] || 'txt'
    "template.#{file_ext}"
  end

  def display_options?
    object.output_format == :pdf
  end
end
