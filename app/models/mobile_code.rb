class MobileCode < ApplicationRecord
  validates :mobile, presence: true, uniqueness: {scope: :message_type, message: '同一手机号的发送类型不同重复'}
  validates :message_type, presence: true
end
