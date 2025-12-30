require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'メソッドの確認' do
    context "save_with_author" do
      let!(:book) { build(:book) }

      it '複数の著者を保存する' do
        author_array = ['author_1', 'author_2']
        expect{ book.save_with_author(author_array) }.to change{ Author.count }.by(2)
        expect(book).to be_valid
        authors = Author.where(name: author_array)
        authors.each do |author|
          expect(book.authors.include? author).to be_truthy
        end
      end

      it '著者が重複している場合、重複を取り除いて著者を保存する' do
        author_array = ['author', 'author']
        expect{ book.save_with_author(author_array) }.to change{ Author.count }.by(1)
        expect(book).to be_valid
        authors = Author.where(name: author_array)
        authors.each do |author|
          expect(book.authors.include? author).to be_truthy
        end
      end
      
      it '著者がすでに保存されている場合、新規に著者を保存しない' do
        author = create(:author)
        author_array = [author.name]
        expect{ book.save_with_author(author_array) }.to change{ Author.count }.by(0)
        expect(book).to be_valid
        authors = Author.where(name: author_array)
        authors.each do |author|
          expect(book.authors.include? author).to be_truthy
        end
      end
      
      it '著者が空文字の場合、著者を保存しない' do
        book = build(:book)
        author_array = ['']
        expect{ book.save_with_author(author_array) }.to change{ Author.count }.by(0)
        expect(book).to be_valid
      end
      
      it 'author_arrayが空配列の場合、著者を保存しない' do
        book = build(:book)
        author_array = []
        expect{ book.save_with_author(author_array) }.to change{ Author.count }.by(0)
        expect(book).to be_valid
      end
      
      it '本のバリデーションが無効な場合、著者を保存しない' do
        book = build(:book, body: nil)
        author_array = ['author_1', 'author_2']
        expect{ book.save_with_author(author_array) }.to change{ Author.count }.by(0)
        expect(book).to be_invalid
      end
    end
  end

  describe 'バリデーション確認' do
    it '有効であること' do
      book = build(:book)
      expect(book).to be_valid
      expect(book.errors).to be_empty
    end

    it 'タイトルがない場合、無効' do
      book = build(:book, title: nil)
      expect(book).to be_invalid
      expect(book.errors[:title]).to eq ["を入力してください"]
    end

    it 'レビュー内容がない場合、無効' do
      book = build(:book, body: nil)
      expect(book).to be_invalid
      expect(book.errors[:body]).to eq ["は5文字以上で入力してください"]
    end

    it 'レビュー内容が5文字より小さい場合、無効' do
      book = build(:book, body: 'a' * 4)
      expect(book).to be_invalid
      expect(book.errors[:body]).to eq ["は5文字以上で入力してください"]
    end

    it 'レビュー内容が2000文字より大きい場合、無効' do
      book = build(:book, body: 'a' * 2001)
      expect(book).to be_invalid
      expect(book.errors[:body]).to eq ["は2000文字以内で入力してください"]
    end
  end
end
