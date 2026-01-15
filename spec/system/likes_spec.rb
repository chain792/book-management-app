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

        expect(page).to have_selector('[data-testid="like-button"]')

        expect {
          find('[data-testid="like-button"]').click
          expect(page).to have_selector('[data-testid="unlike-button"]')
        }.to change { Like.count }.by(1)

        expect(page).to have_current_path book_path(book)
      end

      it 'いいね解除できる' do
        book = like_by_me.book

        visit book_path(book)

        expect(page).to have_selector('[data-testid="unlike-button"]')

        expect {
          find('[data-testid="unlike-button"]').click
          expect(page).to have_selector('[data-testid="like-button"]')
        }.to change { Like.count }.by(-1)

        expect(page).to have_current_path book_path(book)
      end
    end
  end
end
