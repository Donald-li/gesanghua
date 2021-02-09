class Api::Entrance::LingXi::MonthDonatesController < Api::Entrance::LingXi::BaseController

  def synchronize
    logger.info "+++++++++++++++++"
    logger.info request.body.read
    logger.info "+++++++++++++++++"
    params_body = JSON.parse(request.body.string)
    form_params = params_body['form_info']
    if form_params['mobile'].present?
      user = User.find_by(phone: form_params['mobile'])
    elsif form_params['email'].present?
      user = User.find_by(email: form_params['email'])
    else
      user = User.find_by(name: form_params['name'])
    end
    unless user.present?
      user = User.create(name: form_params['name'], phone: form_params['mobile'], email: form_params['email'])
    end
    if params_body['type'] != 'pay'
      return api_success
    end
    return api_success if IncomeRecord.where(
      fund_id: Settings.month_donate_fund_id,
      income_source_id: IncomeSource.wechat_id,
      kind: :offline).where(
      "archive_data ->> 'flow_number' = ?", form_params['flow_number']
    ).present?
    if IncomeRecord.create(
      donor: user,
      agent: user,
      fund_id: Settings.month_donate_fund_id,
      income_source_id: IncomeSource.wechat_id,
      amount: params_body['money'],
      balance: params_body['money'],
      income_time: Time.now,
      remark: params_body['comment'],
      title: '灵析月捐项目爱心款',
      kind: :offline,
      archive_data: params_body
    )
      api_success(message: '保存成功')
    else
      api_error(message: '保存失败')
    end
  end

end

# {
#     "money": "0.1",
#     "flow_number": "4200000403201909176588127252",
#     "bind_id": "72007",
#     "oid": "107868503",
#     "order_id": "107868503",
#     "source": "\u5fae\u4fe1\u5b9a\u671f\u6350\u6b3e",
#     "comment": "",
#     "pay_time": "1568701802",
#     "form_info": {
#         "name": "\u5f90\u767e\u6052",
#         "email": "17660643271@163.com",
#         "mobile": "17660643271",
#         "_token": "nFR2s2RbK1NEvWSjlNKOgBfmapkqyoLQKK0JI1z0",
#         "donate_amount": "0.1",
#         "money_desc": "",
#         "bracket_id": "",
#         "pay_account_id": "4056",
#         "must_read": "1",
#         "utm_bccid": "0",
#         "broadcast_channel_id": "0",
#         "ip": "119.165.180.180",
#         "browser_user_agent": "Mozilla\/5.0 (Linux; Android 9; LYA-AL00 Build\/HUAWEILYA-AL00; wv) AppleWebKit\/537.36 (KHTML, like Gecko) Version\/4.0 Chrome\/67.0.3396.87 XWEB\/986 MMWEBSDK\/190507 Mobile Safari\/537.36 MMWEBID\/492 MicroMessenger\/7.0.6.1500(0x2700063E) Process\/tools NetType\/WIFI Language\/zh_CN",
#         "browser_referer": "https:\/\/cf.lingxi360.com\/p\/ca7zx2eqwovy9021p313kd483gmnp5rl?_setting_form_popup=1&utm_bccid=ca17nxo5qvzl9gm10q507w3rp24e8ykw"
#     },
#     "cid": "camrp4nyx9v1w0yov8zledgzloqk783e",
#     "extra_params": "",
#     "outer_uid": "",
#     "type": "pay",
#     "success": "1",
#     "project_info": {
#         "id": "102210866",
#         "title": "\u683c\u6851\u82b1\u6708\u6350",
#         "eid": "ca7zx2eqwovy9021p313kd483gmnp5rl"
#     },
#     "stamp": 1568701805,
#     "noncestr": "45bspSufr1mbIjRH",
#     "api_key": "jmz9q5esqoze",
#     "signature": "ae220caef36b4cf6fa279d5e9c25051156b6c11f390980ebe06832b0c026083e"
# }
