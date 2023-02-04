FactoryGirl.define do
  factory :tag, class: Tag do
    sequence(:name) { |n| "name#{n}" }
    sequence(:arguments) { |n| "(arg#{n}=true)" }
    description 'Описание'

    template_info
  end
end
