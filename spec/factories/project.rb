FactoryBot.define do
  sequence :name do |n|
    "project#{n}"
  end

  factory :project do
    name
    status { 'inactive' }
    estimated_end_date { '01-01-2023' }
  end
end