require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  describe 'いいね機能' do
    let(:me) { create(:user) }
    let(:book) { create(:book) }
    let(:like_by_me) { create(:like, user: me) }
    before { login_as(me) }

    context '正常系' do
      it 'いいねできる' do
        visit book_path(book)
        expect(page).not_to have_selector 'i.bi.bi-heart-fill'
        expect{
          find('i.bi.bi-heart').click
          expect(page).to have_selector 'i.bi.bi-heart-fill'
        }.to change{ Like.count }.by(1)
        expect(current_path).to eq book_path(book)
      end

      it 'いいね解除できる' do
        visit book_path(like_by_me.book)
        expect(page).not_to have_selector 'i.bi.bi-heart'
        expect{
          find('i.bi.bi-heart-fill').click
          expect(page).to have_selector 'i.bi.bi-heart'
        }.to change{ Like.count }.by(-1)
        expect(current_path).to eq book_path(like_by_me.book)
      end
    end
  end
end
