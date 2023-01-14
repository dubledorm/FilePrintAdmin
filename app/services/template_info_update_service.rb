# frozen_string_literal: true

# Найти Template_info по переданному template_info_id
# Если передан template_content, то заменить его в связанной записи Template, изменив при этом updated_at
# Изменить атрибуты у записи Template_info
class TemplateInfoUpdateService

  def self.call(template_info_id, template_info_attributes, template_content)
    template_info = TemplateInfo.find(template_info_id)
    template_info.attributes = template_info_attributes
    return template_info unless template_info.valid?

    update_template(template_info, template_content) unless template_content.blank?

    return template_info unless template_info.errors.messages.empty?

    template_info.save
    template_info
  end

  class << self

    private

    def update_template(template_info, template_content)
      template = template_info.template
      template.content = BSON::Binary.new(template_content)
      template.updated_at = Time.now
      template.save
      template_info.errors.messages[:content] = ['Ошибка при сохранении'] unless template.persisted?
    end
  end
end
