require 'uri'
require "net/http"

module Baidu
  # 签名的算法
  def self.auth_str(method: 'GET', url: '', timestamp: "", headers: {})
    uri = URI.parse(URI.encode(url))
    canonical_uri = uri.path
    canonical_query = uri.query.to_s.split('&').sort.join('&')
    canonica_headers = headers.map{|k,v| "#{k.downcase}:#{URI.encode(v)}"}.sort.join("\n")
    signed_headers = canonica_headers.split("\n").map{|h| h.split(':').first}.join(';')

    canonical_request = [method, canonical_uri, canonical_query, canonica_headers].join("\n")

    secret_key = 'baidu-aaaaaaa'
    access_id = '18bf2b9a12834efebc1643bdf4efb933'

    signing_str = "bce-auth-v1/#{access_id}/#{timestamp}/1800"
    signing_key = OpenSSL::HMAC.hexdigest('SHA256', secret_key, signing_str)

    signature = OpenSSL::HMAC.hexdigest('SHA256', signing_key, canonical_request)

    "#{signing_str}/#{signed_headers}/#{signature}"
  end

  def self.send_sms()
    host = "sms.bj.baidubce.com"
    path = '/bce/v2/message'
    timestamp = Time.now.utc.strftime('%FT%TZ')
    method = 'POST'
    content = {
      invokeId: 'd2iL60UT-7N8-2236',
      phoneNumber: '18601299553',
      templateCode: 'smsTpl:6nHdNumZ4ZtGaKO',
      contentVar: {code: '2912'}
    }
    signed_content = Digest::SHA2.hexdigest(content.to_json)

    headers = {
      'Content-Type': 'application/json',
      'Authorization': auth_str(method: method, url: path, headers: {}),
      'x-bce-date': timestamp,
      'x-bce-content-sha256': signed_content
    }

    http = Net::HTTP.new(host)
    req = Net::HTTP::Post.new(path, headers)
    req.set_form_data(content)
    res = http.request(req)


  end
end
