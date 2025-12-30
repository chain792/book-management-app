class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  has_many :books, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_books, through: :likes, source: :book
  # フォローしている関係
  has_many :active_relationships, class_name: :Relationship, foreign_key: :followed_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  # フォローされている関係
  has_many :passive_relationships, class_name: :Relationship, foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :followed

  validates :password, length: { minimum: 4 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 16 }
  validates :introduction, length: { maximum: 1000  }

  enum :role, { general: 0, admin: 1, guest: 2 }

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    image = auth_hash[:info][:image]
    random_value = SecureRandom.alphanumeric(10) + Time.zone.now.to_i.to_s
    email = auth_hash[:info][:email]
    
    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = name
      user.remote_avatar_url = image
      user.email = email
      user.password = random_value
      user.password_confirmation = random_value
    end
  end

  def own?(object)
    id == object.user_id
  end

  def like?(book)
    like_books.include? book
  end

  def like(book)
    like_books << book
  end

  def unlike(book)
    likes.find_by(book_id: book.id).destroy!
  end

  def follow?(user)
    followings.include? user
  end

  def follow(user)
    followings << user
  end

  def unfollow(user)
    active_relationships.find_by(follower_id: user.id).destroy!
  end
end
