/**
 * Created by huaxiukun on 16/5/30.
 */
$(function () {
    var is_sending;
    is_sending = false;
    $('#btn_send_mobile_code').click(function () {
        var mobile, captcha, mobile_number, self;
        self = $(this);
        if (is_sending) {
            return;
        }
        mobile = $('#' + self.attr('data-key') + '_mobile');
        captcha = $('input[name="_rucaptcha"]').val();
        mobile_number = mobile.val();
        if (captcha == '' || captcha == null) {
            alert('请输入校验码');
            $('input[name="_rucaptcha"]').focus();
            return;
        }
        if (mobile_number === '' || mobile_number.length !== 11 || isNaN(mobile_number)) {
            alert('手机号码格式不正确');
            mobile.focus();
            return;
        } else {

            $.ajax({
                url: '/accounts/validate_captcha',
                type: 'POST',
                data: {"_rucaptcha": captcha},
                success: function (data) {

                    if (data[0]) {
                        self.blur();
                        is_sending = true;
                        self.text('发送中...').addClass('disabled');
                        return $.ajax({
                            url: '/accounts/send_code',
                            type: 'POST',
                            data: {
                                "mobile": mobile_number,
                                "type": self.attr('data-type')
                            },
                            success: function (data) {
                                return alert(data[1]);
                            },
                            error: function (data) {
                                return alert(data[1]);
                            },
                            complete: function () {
                                is_sending = false;
                                return self.text('获取验证码').removeClass('disabled');
                            }
                        });
                    } else {
                        alert(data[1]);
                        $('input[name="_rucaptcha"]').focus();

                    }
                    refresh_captcha();
                }

            });
        }

    });
    $('.refresh-captcha').on('click', function () {
        refresh_captcha();
    });

    // 检测用户名是否存在
    $('#sing_up_nickname,#user_nickname').blur(function () {
        var nickname = trim($('#sing_up_nickname,#user_nickname').val());
        if (nickname) {
            $.ajax({
                url: '/accounts/register_nickname_exists',
                type: 'POST',
                data: {"nickname": nickname},
                success: function (data) {
                    if (data) {
                        alert(nickname + '已经存在,请更改用户名')
                    }
                }
            });
        }
    });

});
function refresh_captcha() {
    var src = $("img.rucaptcha-image").attr('src');
    $('.refresh-captcha').find('img').attr('src', src.split('cha/')[0] + 'cha/?' + (new Date()).getTime());
}

