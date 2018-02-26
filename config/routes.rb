Rails.application.routes.draw do

  root to: 'site/mains#show'

  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end

  draw :concern
  draw :admin
  draw :site
  draw :api
  draw :support

  mount RuCaptcha::Engine => "/rucaptcha"
  mount ChinaCity::Engine => '/china_city'

end
