FactoryBot.define do
  factory :comment do
    sequence(:body, 'comment_1')
    association :user
    association :book
  end
end
