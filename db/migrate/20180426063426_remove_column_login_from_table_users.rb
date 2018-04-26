class RemoveColumnLoginFromTableUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :login, :string
    # 修改openid和uniconid
    User.all.each do |u|
      next if u.profile.blank?
      u.openid = u.profile['unionid']
      u.save
    end
  end
end
