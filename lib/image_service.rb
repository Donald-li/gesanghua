require "mini_magick"
class ImageService

  def self.tmp_dir
    dir = "#{Rails.root}/tmp/image"
    FileUtils.mkdir(dir) unless File.exists?(dir)
    dir
  end

  def self.composite(image_paths)
    to_path = "#{tmp_dir}/composite_#{SecureRandom.uuid.to_s.strip}.jpeg"
    montage_commond = image_paths + ["-dissolve", "15", "-tile", to_path]
    # montage_commond = image_paths + ["-dissolve", "15", "-tile", "-quality", "70", to_path]
    MiniMagick::Tool::Montage.new {|m| m.merge! montage_commond}
    to_path
  end

  def self.compress(image_path, watermark = false)
    to_path = "#{tmp_dir}/compress_#{SecureRandom.uuid.to_s.strip}.jpeg"
    image = MiniMagick::Image.open image_path
    image.combine_options do |b|
      b.strip
      b.quality "60"
    end
    if watermark
      watermark_image = MiniMagick::Image.open("#{Rails.root}/public/images/water.png")
      watermark_width = (image.width * 0.1).to_i
      watermark_height = (watermark_image.height * (watermark_width / watermark_image.width.to_f)).to_i
      watermark_image.resize "#{watermark_width}x#{watermark_height}"
      image = image.composite(watermark_image)
    end
    image.write to_path
    to_path

  end
end
