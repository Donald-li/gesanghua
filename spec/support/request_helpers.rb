module RequestHelpers
  def api_v1_headers(user=nil, headers={})
    user ||= create(:user)
    { 'Authorization' =>user.try(:auth_token)}.merge(headers)
  end

  def api_v1_expect_success(data = {})
    expect_json({ status: 0 }.merge(data))
  end

  def api_v1_expect_error(data = {})
    expect_json({ status: 400 }.merge(data))
  end

  def api_v1_expect_require_params
    expect_json({ status: 300, message: /必传参数/ })
  end

  def api_v1_expect_invalid_params
    expect_json({ status: 301, message: /参数不合法/ })
  end

  def api_v1_expect_login_require
    expect_json({ status: 402, message: /登录/ })
  end

  def api_v1_expect_deny_access
    expect_json({ status: 403, message: /没有权限/ })
  end

end
