FactoryBot.define do
  factory :book do
    sequence(:title, "title_1")
    body { 'レビュー内容です' }
    book_image { "MyString" }
    published_date { "2022-05-01" }
    info_link { 'https://google.com' }
    association :user
    association :category
  end
end
