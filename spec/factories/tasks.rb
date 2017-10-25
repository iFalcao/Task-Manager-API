FactoryGirl.define do
  factory :task do
    title "MyString"
    description "MyText"
    done false
    deadline "2017-10-24 21:30:00"
    user nil
  end
end
