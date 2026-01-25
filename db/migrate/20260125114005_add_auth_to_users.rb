class AddAuthToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password_digest, :string
    remove_column :users, :crypted_password, :string
    remove_column :users, :salt, :string
  end
end
