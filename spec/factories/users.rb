FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "test#{n}" }
    sequence(:email) { |n| "test#{n}@gmail.com" }
    password { 'password' }
    password_confirmation { 'password' }
    sequence(:confirmation_token) { |n| "test_Test_test_Test#{n}" }
    confirmation_sent_at { Date.today }
    confirmed_at { Date.today }

    trait :guest do
      email { 'guest@example.com' }
      name { 'ゲスト' }
      password { SecureRandom.urlsafe_base64 }
    end

    factory :user_with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/test_avatar.jpg')),
          filename: 'test_avatar.jpg',
          content_type: 'image/jpg'
        )
      end
    end
  end
end
