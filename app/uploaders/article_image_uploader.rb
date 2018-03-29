class ArticleImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [284, 284]
  end

  version :medium do #pc端首页资讯图
    process :resize_to_fill => [360, 208]
  end

end
