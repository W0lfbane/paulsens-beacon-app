FactoryGirl.define do
  factory :user do
    email 'example@example.com'
    password 'please'
    password_confirmation 'please'

    factory :admin do
        after(:create) {|user| user.add_role(:admin)}
    end

  end
end