class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         has_one_attached :image

  validates :name, length: { maximum: 40 }

  # has_many :groups, dependent: :destroy
  has_and_belongs_to_many :groups
  has_many :expenses, dependent: :destroy
  has_many :comments

end
