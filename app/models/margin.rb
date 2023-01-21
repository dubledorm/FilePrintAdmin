# frozen_string_literal: true

# Содержит дополнительные параметры, используемые для печати документа
# Явдяется встроенныи документом в TemplateInfo
class Margin
  include Mongoid::Document

  embedded_in :template_option

  field :top, type: Integer
  field :bottom, type: Integer
  field :left, type: Integer
  field :right, type: Integer

  validates :top, :bottom, :left, :right, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                                          allow_blank: true
end
