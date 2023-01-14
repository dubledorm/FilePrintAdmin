# frozen_string_literal: true

# Содержит непосредственно сам шаблон.
class Template
  include Mongoid::Document

  field :content, type: BSON::Binary
  field :updated_at, type: DateTime
end
