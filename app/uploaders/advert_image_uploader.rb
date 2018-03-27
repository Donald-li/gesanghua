class AdvertImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [1014, 604]
  end

  version :large do #微信端首页banner
    process :resize_to_fill => [640, 380]
  end
end
