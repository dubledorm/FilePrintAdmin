# frozen_string_literal: true

# Обновить список тегов для template_infos
class RefreshTagsService

  def self.refresh(template_info)
    tags = HttpService.new.tags!(template_info.name) # Запрашиваем тэги из документа
    add_tags(template_info, tags)
    remove_unused_tags(template_info, tags)
    template_info.save
  end

  private

  def self.add_tags(template_info, tags)
    tags.each do |tag_and_arguments_hash|
      description = ''
      example = ''
      existed_tag = template_info.tags.find_all { |tag| tag.name == tag_and_arguments_hash['name'] }.first
      if existed_tag
        description = existed_tag.description || ''
        example = existed_tag.example || ''
        template_info.tags.delete(existed_tag)
      end
      template_info.tags << Tag.new(name: tag_and_arguments_hash['name'],
                                    arguments: tag_and_arguments_hash['arguments'].to_s,
                                    description: description,
                                    example: example)
    end
  end

  def self.remove_unused_tags(template_info, tags)
    removed_tag_names = template_info.tags.map(&:name) - tags.map { |item| item['name'] }
    removed_tags = template_info.tags.find_all { |tag| removed_tag_names.include?(tag.name) }
    removed_tags.each do |removed_tag|
      template_info.tags.delete(removed_tag)
    end
  end
end

