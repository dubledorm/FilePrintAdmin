# frozen_string_literal: true

module ActiveAdmin
  module Inputs
    module Filters
      # Заменяем метод searchable_method_name. В исходном коде проблема в том, что если мы используем
      # например такую строчку:
      # filter :output_format, as: :check_boxes, collection: proc { TemplateInfo::OUTPUT_FORMAT_VALUES.map { |item| [item, item.to_s] } }
      # то, если output_format не является ассоциацией, то reflection.key || method упадёт, т.к. reflection будет null
      # Требуется добавить & чтобы нормально работало
      class CheckBoxesInput
        def searchable_method_name
          if searchable_has_many_through?
            "#{reflection.through_reflection.name}_#{reflection.foreign_key}"
          else
            reflection&.key || method
          end
        end
      end
    end
  end
end
