# frozen_string_literal: true

# Содержит всю служебную информацию о шаблоне, кроме тела шаблона
# Шаблон вынесен в отдельную таблицу, чтобы размер этой записи был минимальный
class TemplateInfo
  include Mongoid::Document

  OUTPUT_FORMAT_VALUES = %i[pdf xls].freeze

  field :name, type: String
  field :rus_name, type: String
  field :description, type: String
  field :output_format, type: Symbol
  field :state, type: Symbol

  embeds_one :options, class_name: 'TemplateOption'
  has_many :tags, class_name: 'Tag', dependent: :destroy
  belongs_to :template, dependent: :destroy, validate: true

  accepts_nested_attributes_for :tags, allow_destroy: true
  accepts_nested_attributes_for :template
  accepts_nested_attributes_for :options

  validates :name, :rus_name, :output_format, presence: true
  validates :output_format, inclusion: { in: OUTPUT_FORMAT_VALUES }
  validates :name, uniqueness: true

  index({ name: 1 }, { unique: true, name: 'name_index' })
  index({ output_format: 1 }, { unique: false, name: 'output_format_index' })

  after_initialize do
    unless persisted?
      build_template unless template
      build_options unless options
    end
  end
end
