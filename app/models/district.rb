class District < ApplicationRecord
  has_many :user_profiles
  validates :name, presence: true, uniqueness: {scope: :city, message: '同一城市的区县不同重复'}
  validates :city, presence: true
end
