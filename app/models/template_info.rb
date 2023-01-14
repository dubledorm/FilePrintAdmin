# frozen_string_literal: true

# Содержит всю служебную информацию о шаблоне, кроме тела шаблона
# Шаблон вынесен в отдельную таблицу, чтобы размер этой записи был минимальный
class TemplateInfo
  include Mongoid::Document

  STATE_VALUES = %i[new stable].freeze
  OUTPUT_FORMAT_VALUES = %i[pdf xls].freeze

  field :name, type: String
  field :rus_name, type: String
  field :description, type: String
  field :output_format, type: Symbol
  field :state, type: Symbol

  belongs_to :template, optional: true, dependent: :destroy

  validates :state, :name, :rus_name, :output_format, presence: :true
  validates :state, inclusion: { in: STATE_VALUES }

  validates :output_format, inclusion: { in: OUTPUT_FORMAT_VALUES }

  validates :name, uniqueness: true


  index({ name: 1 }, { unique: true, name: "name_index" })
  index({ state: 1 }, { name: "state_index" })
end
