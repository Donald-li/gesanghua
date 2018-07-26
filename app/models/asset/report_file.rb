# == Schema Information
#
# Table name: assets # 资源表
#
#  id            :bigint(8)        not null, primary key
#  type          :string
#  owner_type    :string
#  owner_id      :integer
#  position      :integer
#  file          :string
#  file_name     :string
#  file_size     :integer
#  width         :integer
#  height        :integer
#  user_type     :string
#  user_id       :integer
#  protect_token :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Asset::ReportFile < Asset
  after_destroy :destroy_activity
  mount_uploader :file, AssetUploader

  #删除附件
  def destroy_activity

  end
end
