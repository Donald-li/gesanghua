if defined? Rails && Rails::VERSION::MAJOR >=3 && Rails::VERSION::MINOR >= 1
  require "echarts-rails/engine"
else
  puts "You should use Rails 3.1+ and higher with echarts-rails!"
end
