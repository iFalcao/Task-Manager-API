FactoryGirl.define do
  factory :task do
    title { Faker::StarWars.character }
    description { Faker::Lorem.paragraph }
    done false
    deadline { Faker::Date.forward }
    user
  end
end
