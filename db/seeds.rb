# Categories
categories = [
  { name: 'プログラミング', children: [
    'Ruby', 'PHP', 'JavaScript', 'Python', 'C/C++', 'C#', 'Java', 'HTML/CSS', 'その他プログラミング言語'
  ]},
  { name: 'コンピュータテクノロジー', children: [
    'データベース', 'インフラ/ネットワーク', 'AI・機械学習', 'コンピュータテクノロジー全般'
  ]},
  { name: 'その他', children: [
    '小説・ノベルズ', '教養', '趣味', 'コミック・雑誌'
  ]}
]

categories.each do |cat_data|
  parent = Category.find_or_create_by!(name: cat_data[:name])
  cat_data[:children].each do |child_name|
    parent.children.find_or_create_by!(name: child_name)
  end
end
