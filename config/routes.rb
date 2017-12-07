Rails.application.routes.draw do

  root to: 'site/mains#show'

  scope module: :site do
  end
end
