require 'mini_magick'
require 'fileutils'
include MiniMagick
include ActionView::Helpers::NumberHelper
class GenDonateCertificate
  class << self
    def create(record)
      source = Image.open(Rails.root.to_s + "/lib/certificate/certificate_template.jpg")
      # donors = record.items.donor.all
      # return if donors.blank?
      name = record.donor.try(:card_name)
      # name |= '用户'

      render_text(source, 60, 260, "亲爱的") {|c| c.pointsize '24'}
      render_text(source, 132, 260, "#{name}：") do |c|
        c.pointsize '24'
        # c.weight 600
      end

      content1 ="　　感谢您为支持格桑花西部助学慷慨捐赠"
      amount = "#{number_to_currency record.amount}元"
      content2 ="。谨代表受助学生向您表示最崇高的敬意和衷心的感谢！\n　　特颁此证，以资纪念。"
      render_text(source, 60, 300, content1)

      length = (amount.length + 1) * 11
      render_text(source, 60, 340, amount) do |c|
        c.pointsize '22'
        c.fill '#d22ca4'
        # c.weight 600
      end

      render_content(source, content2, amount, length)

      donate_at = record.created_at
      render_text(source, 360, 580, "#{donate_at.year}年#{donate_at.month}月#{donate_at.day}日") do |c|
        c.pointsize '18'
      end

      render_text(source, 60, 650, "捐赠编号：#{record.certificate_no}") do |c|
        c.pointsize '20'
      end

      file_name = Encryption.md5(record.certificate_no.to_s)
      rel_path = "/images/certificates/#{record.created_at.strftime('%Y%m%d')}/#{record.id}"
      path_name = Rails.root.to_s + '/public' + rel_path
      FileUtils.mkpath(path_name) unless File.directory?(path_name)
      source.quality('100')
      source.write(path_name + "/#{file_name}.jpg")
    end
  end

  def self.format_text(text)
    text.gsub("\r\n", "\n").each_line.map do |line|
      str = ""; index = 1
      line.each_char { |chr| str << chr; index += (chr.ord < 129 ? 1 : 2); str << "\n" and index = 1 if index > 37 }
      str
    end.join
  end

  def self.render_content(src, message, amount, length)
    formated_text = format_text(amount + message)
    formated_text.each_line.each_with_index do |line, index|
      left = index == 0 ? 60 + length : 60
      line = index == 0 ? line.delete!(amount) : line
      render_text(src, left, 340 + index * 40, line)
    end
  end

  def self.render_text(src, left, top, line, &block)
    return unless line.present?
    src.combine_options do |c|
      c.font File.expand_path('..', __FILE__) + '/certificate/simsun.ttc'
      c.fill '#000'
      c.pointsize '22'
      block.call(c) if block_given?
      c.draw "text #{left},#{top} '#{line}'"
    end
  end

end
