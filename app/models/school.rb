class School < ApplicationRecord
  has_many :user_profiles
  validates :name, presence: true
  validates :district_id, presence: true
  validates :school_type, presence: true
end
