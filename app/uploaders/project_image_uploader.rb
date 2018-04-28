class ProjectImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [960, 510]
  end

  version :medium do
    process :resize_to_fill => [640, 340]
  end

  # version :small do
  #   process :resize_to_fill => [220, 160]
  # end

  version :large do #pc端项目介绍页
    process :resize_to_fill => [1140, 280]
  end
end
