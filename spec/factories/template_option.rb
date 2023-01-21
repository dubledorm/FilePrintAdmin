FactoryGirl.define do
  factory :template_option, class: TemplateOption do
    orientation :Portrait
    page_size :A4
    header_html ''
  end
end
