class UserProfile < ApplicationRecord
  belongs_to :user
  belongs_to :school, optional: true
  belongs_to :district, optional: true
  GENDER = {male: 1, female: 2}
end
