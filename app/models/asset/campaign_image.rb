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

class Asset::CampaignImage < Asset

  mount_uploader :file, CampaignImageUploader

end
