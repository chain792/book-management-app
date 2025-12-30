require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーション確認' do
    let(:created_like) { create(:like) }

    it '有効であること' do
      like = build(:like)
      expect(like).to be_valid
      expect(like.errors).to be_empty
    end

    it '重複している組み合わせの場合、無効' do
      like = build(:like, user: created_like.user, book: created_like.book)
      expect(like).to be_invalid
      expect(like.errors[:user_id]).to eq ["はすでに存在します"]
    end
  end
end
