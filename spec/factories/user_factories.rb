FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'b1gSecret'
  end

end
