class EmailService

  TYPE_CODE_ADD_EMAIL_CODE = 'ADD_EMAIL'

  # 构造方法
  def initialize(email)
    @email = email
  end


  def send_email_code(type, ip)
    unless Regular.is_email?(@email)
      return [FALSE, '邮箱格式错误']
    end
    user = User.where(email: @email).exists?
    if user and type == TYPE_CODE_ADD_EMAIL_CODE
      return [FALSE, '该邮箱已经被使用了']
    end
    if EmailCode.where('created_at > ?', Time.now - 300).count > 10
      return [FALSE, '发送密度过大，请稍等重试']
    end
    code = rand(100000..999999) # 获取随机码
    row = EmailCode.find_by(email: @email, message_type: type) # 检测是否已经存在同类型记录
    if row.nil?
      EmailCode.create!(email: @email, code: code, message_type: type, ip: ip) # 如果不存在则直接生成新记录
    elsif row.updated_at + 2 * 60 < Time.now
      # 如果存在同类型记录，但已经超过发送间隔，则根据新的代码重新发送
      row.code = code
      row.save
    else
      # 如果存在同类型记录，但小于发送间隔，则不重新发送
      return [FALSE, '验证码发送间隔为2分钟']
    end

    status = UserMailer.user_add_email_code(@email, code).deliver
    if status != nil
      [TRUE, '验证码已发送到您的邮箱']
    else
      [FALSE, '验证码发送失败']
    end
  end

  # 检测邮箱验证码
  def validate?(code, type)
    unless Regular.is_email?(@email)
      return [FALSE, '邮箱格式错误']
    end

    # 检测邮箱验证码格式
    unless Regular.is_mobile_code?(code)
      return [FALSE, '验证码不正确或格式错误']
    end

    row = EmailCode.find_by(email: @email, message_type: type)
    if row.nil?
      return [FALSE, '该邮箱没发送过此类型验证码 或 验证码已超时']
    end

    # 检测是否超时及是否超过尝试次数
    if (row.updated_at + 10.minutes < Time.now) or (row.failed_attempts.to_i + 1 > 5)
      row.destroy
      return [FALSE, '验证码已超时或尝试超过5次']
    else
      if row.code == code
        row.destroy
        [TRUE, '验证码成功通过验证']
      else
        row.failed_attempts = row.failed_attempts.to_i + 1
        row.save
        [FALSE, '邮箱验证码不正确']
      end
    end
  end
end