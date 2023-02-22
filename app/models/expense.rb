class Expense < ApplicationRecord
  include PublicActivity::Model
  # tracked owner: ->(controller, model) { controller && controller.current_user }

  validates :name, presence: true, length: { maximum: 20 }
  validates :amount, presence: true, numericality: { less_than_or_equal_to: 100_000, greater_than: 1 }

  belongs_to :user
  belongs_to :group ,optional: true
  has_many :splits, dependent: :destroy

  has_one_attached :profile_photo
  
end
