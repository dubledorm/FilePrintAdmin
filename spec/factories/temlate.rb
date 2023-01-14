FactoryGirl.define do
  factory :template, class: Template do
    content BSON::Binary.new('<HTML>Body</HTML>')
  end
end
