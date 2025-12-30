programming = Category.seed(:name, name: 'プログラミング')
programming[0].children.seed(:name,
  { name: 'Ruby' },
  { name: 'PHP' },
  { name: 'JavaScript' },
  { name: 'Python' },
  { name: 'C/C++' },
  { name: 'C#' },
  { name: 'Java' },
  { name: 'HTML/CSS' },
  { name: 'その他プログラミング言語' }
)

computer_technology = Category.seed(:name, name: 'コンピュータテクノロジー')
computer_technology[0].children.seed(:name,
  { name: 'データベース' },
  { name: 'インフラ/ネットワーク' },
  { name: 'AI・機械学習' },
  { name: 'コンピュータテクノロジー全般' }
)

others = Category.seed(:name, name: 'その他')
others[0].children.seed(:name,
  { name: '小説・ノベルズ' },
  { name: '教養' },
  { name: '趣味' },
  { name: 'コミック・雑誌' }
)