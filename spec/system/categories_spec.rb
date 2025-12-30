require 'rails_helper'

RSpec.describe 'Profiles', type: :system do
  describe 'カテゴリーの一覧と表示' do
    let(:user) { create(:user) }
    before { login_as(user) }

    context '正常系' do
      it '20個のカテゴリーがあること' do
        expect(Category.count).to eq 20
      end

      it 'カテゴリー一覧が表示される' do
        visit categories_path
        Category.all.each do |category|
          expect(page).to have_content category.name
        end
      end

      it 'Rubyカテゴリの本が表示される' do
        ruby = Category.find_by(name: 'Ruby')
        ruby_book = create(:book, category: ruby)
        visit categories_path
        click_link 'Ruby'
        expect(current_path).to eq category_path(ruby)
        expect(page).to have_content ruby_book.title
      end
    end
  end
end