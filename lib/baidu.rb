require 'uri'
require 'cgi'
require "net/http"

module Baidu
  ACCESS_ID = '18bf2b9a12834efebc1643bdf4efb933'
  SECRET_KEY = '736cf755dc6142768dcd18052c7c7520'
  SMS_HOST = 'smsv3.bj.baidubce.com'
  SMS_SIGN_ID = 'sms-sign-DmojLW91016'
  SMS_TEMPLATE_CODE = 'sms-tmpl-FhwtyC36444'

  # 签名的算法
  def self.auth_str(method: 'GET', url: '', timestamp: Time.now.utc.strftime('%FT%TZ'), headers: {})
    uri = URI.parse(URI.encode(url))
    canonical_uri = uri.path

    canonical_query = uri.query.to_s.split('&').sort.join('&')
    canonica_headers = headers.map{|k,v| "#{CGI::escape(k.to_s.downcase)}:#{CGI::escape(v)}"}.sort.join("\n")
    signed_headers = canonica_headers.split("\n").map{|h| h.split(':').first}.join(';')

    canonical_request = [method, canonical_uri, canonical_query, canonica_headers].join("\n")

    signing_str = "bce-auth-v1/#{ACCESS_ID}/#{timestamp}/1800"
    signing_key = OpenSSL::HMAC.hexdigest('SHA256', SECRET_KEY, signing_str)

    signature = OpenSSL::HMAC.hexdigest('SHA256', signing_key, canonical_request)

    "#{signing_str}/#{signed_headers}/#{signature}"
  end

  def self.send_sms(code: '', mobile: '', type: 'signup')
    if type == 'find_password'
      template = 'sms-tmpl-mCTxNs19665'
    else
      template  = SMS_TEMPLATE_CODE
    end

    path = '/api/v3/sendSms'
    timestamp = Time.now.utc.strftime('%FT%TZ')
    method = 'POST'
    body = {
      signatureId: SMS_SIGN_ID,
      mobile: mobile,
      template: template,
      contentVar: {code: code.to_s}
    }.to_json
    signed_content = Digest::SHA256.hexdigest(body)

    headers = {
      'Host': SMS_HOST,
      'Content-Type': 'application/json',
      'x-bce-date': timestamp,
      'x-bce-content-sha256': signed_content
    }
    auth_str = auth_str(method: method, url: path, timestamp: timestamp, headers: headers)
    headers.merge!(Authorization: auth_str)

    http = Net::HTTP.new(SMS_HOST)
    res = http.post(path, body, headers)
    JSON.parse(res.body)
  end

  def self.send_test
    host = 'smsv3.bj.baidubce.com'
    path = '/api/v3/sendSms'
    # host = 'bcc.bj.baidubce.com'
    # path = '/v2/volume/v-NZP6K01R'

    timestamp = Time.now.utc.strftime('%FT%TZ')
    method = 'GET'

    content = {}
    signed_content = Digest::SHA2.hexdigest(content.to_json)

    headers = {
      'Host': host,
      'Content-Type': 'application/json',
      'x-bce-date': timestamp,
      'x-bce-content-sha256': signed_content
    }

    auth_str = auth_str(method: method, url: path, timestamp: timestamp, headers: headers)
    headers.merge!(Authorization: auth_str)

    http = Net::HTTP.new(host)
    res = http.get(path, headers)
    JSON.parse(res.body)

  end
end
