class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :book_image
      t.text :info_link
      t.string :published_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
