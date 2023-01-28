# frozen_string_literal: true

# Обновить список тегов для template_infos
class RefreshTagsService

  def self.refresh(template_info)
    tags = HttpService.new.tags!(template_info.name)
    tags.each do |tag_and_arguments_hash|
      tag = Tag.new(name: tag_and_arguments_hash['name'],
                    arguments: tag_and_arguments_hash['arguments'].to_s)
      template_info.tags << tag
    end

    template_info.save
  end
end

