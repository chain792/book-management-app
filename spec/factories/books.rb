FactoryBot.define do
  factory :book do
    sequence(:title, "title_1")
    body { 'レビュー内容です' }
    # book_image_data は jsonb のため文字列を代入するとエラーになる可能性がある
    published_date { "2022-05-01" }
    info_link { 'https://google.com' }
    association :user
    association :category
  end
end
