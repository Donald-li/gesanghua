class ProjectHeadImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [125, 100]
  end
end
