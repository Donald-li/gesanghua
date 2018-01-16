source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.1'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'

# Use Bootstrap
gem 'bootstrap-sass', '~> 3.3.6'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
gem "redis-namespace"
gem 'redis-rails'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'zip-zip'

# 生成excel
gem 'axlsx', '~>2.1.0.pre'
gem 'axlsx_rails'
# 读取excel
gem 'roo', "~> 2.3.1"

gem 'counter_culture', '~> 1.0'
gem 'kaminari'

# 四级地域级联
gem 'china_city', git: 'https://github.com/caryl/china_city'

gem 'simple_form'
gem 'acts_as_list'

# 图片验证码
gem 'rucaptcha', '~>1.2.0'

gem 'paper_trail'

# 设置默认值
gem "default_value_for", "~> 3.0.0", github: 'eddnb/default_value_for'

#组合查询
gem 'ransack'

# 异步
gem 'sidekiq'

#配置文件
gem 'config'

# 缓存
gem 'second_level_cache', '~> 2.3.0'

# 图片上传和处理
gem 'mini_magick'
gem 'carrierwave', '~>0.11.2'

# 软删除
gem "paranoia", "~> 2.2"

gem 'ruby-pinyin'

#富文本编辑器
gem 'ckeditor'

#二维码生成
gem 'rqrcode'

# 阿里云短信
gem 'aliyun-sms', git: 'https://github.com/songjian/aliyun-sms.git'

#  权限管理
gem "pundit"

# echarts表格
gem 'echarts-rails'

# 定时任务
gem 'whenever', :require => false

# 多级菜单
gem 'ancestry'

# 身份证验证
gem 'chinese_pid'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # 测试
  gem 'rspec-rails', '~> 3.5'
  gem 'database_cleaner'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'airborne'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', branch: 'rails-5'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'simplecov', :require => false, :group => :test
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'annotate'
  gem 'migration_comments'

  # 服务器部署
  gem 'mina'
  gem 'mina-puma', require: false
  gem 'mina-sidekiq', require: false
  gem 'mina-multistage', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
