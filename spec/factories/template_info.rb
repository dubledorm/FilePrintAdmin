FactoryGirl.define do
  factory :template_info, class: TemplateInfo do
    sequence(:name) { |n| "name#{n}" }
    sequence(:rus_name) { |n| "русское имя #{n}" }
    description 'Описание'
    output_format :xls
    template
  end

  factory :template_info_with_options, class: TemplateInfo, parent: :template_info do
    options { FactoryGirl.build(:template_option) }
  end

  factory :template_info_with_tags, class: TemplateInfo, parent: :template_info do
    tags { [FactoryGirl.create(:tag)] }
  end
end
