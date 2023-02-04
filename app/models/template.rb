# frozen_string_literal: true

# Проверяет заполненность данных
class DataPresentValidator < ActiveModel::Validator
  def validate(record)
    return if record.content.is_a?(ActionDispatch::Http::UploadedFile)
    return if record.content&.data&.length&.positive?

    record.errors.add :content, 'The field content should be present'
  end
end

# Содержит непосредственно сам шаблон.
class Template
  include Mongoid::Document


  before_save :fill_content_from_tmp_file

  field :content, type: BSON::Binary
  field :updated_at, type: DateTime
  field :original_file_name, type: String

  validates_with DataPresentValidator

  private

  def fill_content_from_tmp_file
    return unless content.is_a?(ActionDispatch::Http::UploadedFile)

    self.original_file_name = content.original_filename
    self.content = BSON::Binary.new(File.open(content.tempfile.path, 'rb', &:read))
    self.updated_at = Time.now
  end
end
