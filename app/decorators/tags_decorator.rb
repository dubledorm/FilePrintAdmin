# frozen_string_literal: true

# Декоратор для коллекции tags в template_info
class TagsDecorator < Draper::CollectionDecorator
  # Формирует тело запроса для формирования отчёта
  def as_template_params_json
    { template_params: Hash[*object.inject([]) { |result, item| result << [item[:name], item[:example] || ''] }
                                   .flatten].symbolize_keys }
  end
end
