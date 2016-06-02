class AccountsController < ApplicationController
  def index
  end

  # 验证邮箱是否已经注册
  def register_email_exists
    result = User.where(email: params[:email]).exists?
    render json: result
  end

  # 验证手机是否已经注册
  def register_mobile_exists
    result = User.where(mobile: params[:mobile]).exists?
    render json: result
  end

  # 验证昵称是否已经注册
  def register_nickname_exists
    result = User.where(nickname: params[:nickname]).exists?
    render json: result
  end

  def register
    if current_user.present?
      redirect_to root_path
      return
    end
    @sing_up = SingUp.new
  end

  def register_post
    if current_user.present?
      redirect_to root_path
      return
    end
    s_u = params[:sing_up]
    @sing_up = SingUp.new(mobile: s_u[:mobile], mobile_code: s_u[:mobile_code], nickname: s_u[:nickname], password: s_u[:password])
    user = @sing_up.save
    if user.present?
      flash[:success] = '注册成功,请登录!'
      redirect_to_url
    else
      render :register
    end
  end

  def reset_password
    if current_user.present?
      redirect_to root_path
      return
    end
    @reset_password = ResetPassword.new
  end

  def reset_password_post
    if current_user.present?
      redirect_to root_path
      return
    end
    r_p = params[:reset_password]
    @reset_password = ResetPassword.new(mobile: r_p[:mobile], mobile_code: r_p[:mobile_code], password: r_p[:password])
    if @reset_password.save
      flash[:success] = '密码已经成功重置'
      redirect_to root_path
    else
      render :reset_password
    end
  end

  def validate_captcha
    if request.method == 'POST'
      if verify_rucaptcha? params[:_rucaptcha]
        result = [true, '校验码正确']
      else
        result = [false, '校验码输入错误']
      end
    else
      result = [false, '非法请求']
    end
    render json: result
  end

  def send_code
    if params[:type].present? && params[:mobile].present?
      sms = SMSService.new(params[:mobile])
      data = sms.send_code(params[:type], request.ip)
    else
      data = [false, '信息不完整']
    end
    render json: data
  end

  private

  def redirect_to_url
    if cookies[:redirect_url].present?
      redirect_url = cookies[:redirect_url]
      cookies[:redirect_url] = nil
      redirect_to redirect_url
    else
      redirect_to root_path
    end
  end
end