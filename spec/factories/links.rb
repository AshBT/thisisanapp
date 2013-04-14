# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    source "MyString"
    target "MyString"
  end
end
