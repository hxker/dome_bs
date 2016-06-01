class UserProfile < ApplicationRecord
  belongs_to :user
  # belongs_to :school
  # belongs_to :district
  GENDER = {male: 1, female: 2}
end
