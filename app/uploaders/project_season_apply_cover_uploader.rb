class ProjectSeasonApplyCoverUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [888, 510]
  end

  version :little do #微信端我的捐助
    process :resize_to_fill => [206, 150]
  end

  version :small do #微信端项目详情页下申请列表的封面
    process :resize_to_fill => [220, 160]
  end

  version :medium do #微信端首页筹款项目封面
    process :resize_to_fill => [592, 340]
  end

  version :large do #具体筹款项目页的图
    process :resize_to_fill => [640, 340]
  end

end
