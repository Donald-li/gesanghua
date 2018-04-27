namespace :maintain do
  task migrate_user_profile: [:environment] do
    User.all.each do |u|
      next if u.profile.blank?
      u.openid = u.profile['unionid']
      u.save
    end
  end
end
