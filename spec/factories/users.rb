FactoryBot.define do
  factory :user do
    fullname { Faker::Name.name }
    username { Faker::Internet.user_name } #new evaluation for to be unique
    password_digest { Faker::Internet.password } #new evaluation for to be unique
  end
end
