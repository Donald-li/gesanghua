class ProjectSeasonApplyCoverUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [125, 100]
  end

  version :small do
    process :resize_to_fill => [130, 130]
  end

  version :medium do
    process :resize_to_fill => [1014, 608]
  end

end
