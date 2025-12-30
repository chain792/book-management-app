require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'バリデーション確認' do
    it '有効であること' do
      category = build(:category)
      expect(category).to be_valid
      expect(category.errors).to be_empty
    end

    it '名前がない場合、無効' do
      category = build(:category, name: nil)
      expect(category).to be_invalid
      expect(category.errors[:name]).to eq ["を入力してください"]
    end
  end
end
