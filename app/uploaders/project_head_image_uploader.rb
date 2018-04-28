class ProjectHeadImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [1140, 280]
  end

end
