# frozen_string_literal: true

# Описание одного тэга в шаблоне
class Tag
  include Mongoid::Document

  # embedded_in :template_info

  field :name, type: String
  field :arguments, type: String
  field :description, type: String
  field :example, type: String

  belongs_to :template_info

  validates :name, presence: true
  validates :name, uniqueness: { scope: :template_info_id }
end
