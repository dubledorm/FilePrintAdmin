# frozen_string_literal: true

# Сервис создаёт TemplateInfo в состоянии :new, потом сохраняет template
# и записывает ссылку на него в TemplateInfo одновременно меняя состояние на stable
class TemplateInfoCreateService

  def self.call(template_info_attributes, template_content)
    template_info = TemplateInfo.new(template_info_attributes)
    template_info.state = :new
    validate_and_save(template_info, template_content)

    return template_info unless template_info.persisted?

    create_template(template_info, template_content)
    template_info
  end

  class << self

    private

    def validate_and_save(template_info, template_content)
      unless template_info.valid? && template_content
        template_info.errors.messages[:content] = ['Должно быть заполнено']
        return
      end

      template_info.save
    end

    def create_template(template_info, template_content)
      template = Template.create(content: BSON::Binary.new(template_content),
                                 updated_at: Time.now)
      unless template.persisted?
        template_info.delete
        template_info.errors.messages[:content] = ['Ошибка при сохранении']
        return
      end

      template_info.template = template
      template_info.state = :stable
      template_info.save!
    end
  end
end
