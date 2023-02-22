class Group < ApplicationRecord
  include PublicActivity::Model

  validates :name, presence: true, length: { maximum: 20 }
  validates :icon, presence: true

  has_and_belongs_to_many :users
  has_many :expenses, dependent: :destroy
  has_many :splits, through: :expenses
  has_many :comments
  has_one_attached :icon

end  

