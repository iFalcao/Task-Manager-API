FactoryGirl.define do
  factory :user do
    name 'Ícaro Falcão'
    email { Faker::Internet.email }
    password '123456'
    password_confirmation '123456'
  end
end
