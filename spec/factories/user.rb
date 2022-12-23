FactoryBot.define do
  sequence :email do |n|
    "user#{n}@gmail.com"
  end

  factory :user do
    first_name { 'Test' }
    last_name { 'Testov' }
    email
    password { '12345' }
    phone { '54321' }
    post { 'project owner' }
    is_resource { true }
  end
end