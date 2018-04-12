class ArticleCarouselImageUploader < BaseUploader

  process :auto_orient

  version :tiny do
    process :resize_to_fill => [1014, 604]
  end

  version :large do
    process :resize_to_fill => [900, 610]
  end

end
