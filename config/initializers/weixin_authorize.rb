# 这里修改成你的的命名空间。
namespace = "scrm_weixin:weixin_authorize"
redis = Redis.new(:host => "127.0.0.1", :port => "6379", :db => 15)

# 每次重启时，会把当前的命令空间所有的access_token 清除掉。
exist_keys = redis.keys("#{namespace}:*")
exist_keys.each{|key|redis.del(key)}

# Give a special namespace as prefix for Redis key, when your have more than one project used weixin_authorize, this config will make them work fine.
redis_namespace = Redis::Namespace.new("#{namespace}", :redis => redis)

WeixinAuthorize.configure do |config|
  config.redis = redis_namespace
end

#重写功能
module WeixinAuthorize
  class Client
    def http_get(url, url_params={}, endpoint="plain")
      url_params = url_params.merge(access_token_param)
      result = WeixinAuthorize.http_get_without_token(url, url_params, endpoint)
      if result.code == 40001
        self.token_store.refresh_token
        url_params = url_params.merge(access_token_param)
        result = WeixinAuthorize.http_get_without_token(url, url_params, endpoint)
      end
      result
    end

    def http_post(url, post_body={}, url_params={}, endpoint="plain")
      url_params = access_token_param.merge(url_params)
      result = WeixinAuthorize.http_post_without_token(url, post_body, url_params, endpoint)
      if result.code == 40001
        self.token_store.refresh_token
        url_params = url_params.merge(access_token_param)
        result = WeixinAuthorize.http_post_without_token(url, post_body, url_params, endpoint)
      end
      result
    end
  end

end

$client ||= WeixinAuthorize::Client.new(Settings.wechat_app_id, Settings.wechat_app_secret)  # 维基飞翔
