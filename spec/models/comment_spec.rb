require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション確認' do
    it '有効であること' do
      comment = build(:comment)
      expect(comment).to be_valid
      expect(comment.errors).to be_empty
    end

    it '本文がない場合、無効' do
      comment = build(:comment, body: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to eq ["を入力してください"]
    end
  end
end
