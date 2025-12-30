class AddIntroductionToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :introduction, :text, default: 'よろしくお願いします！'
  end
end
