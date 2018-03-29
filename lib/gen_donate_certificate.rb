# -*- encoding : utf-8 -*-
#encoding=UTF-8
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
      name = record.donor_name # TODO 需要考虑代捐人的情况
      # name |= '用户'

      render_text(source, 60, 320, "感谢您！亲爱的#{name}，") {|c| c.pointsize '24'}
      # content = "　　感谢为支持#{project_name}项目慷慨捐赠#{number_to_currency donors.sum(&:amount)}元。谨代表受帮助的孩子向您表示最崇高敬意和衷心感谢！\n　　特颁此证，以资纪念。"
      content = "谢谢你为支持格桑花西部助学#{record.project_name}项目的慷慨捐赠 。 谨代表受帮助的孩子向你表示最崇高敬意和衷心感谢！"
      render_content(source, content)

      donate_at = record.created_at
      render_text(source, 308, 685, "#{donate_at.year}年#{donate_at.month}月#{donate_at.day}日") do |c|
        c.pointsize '20'
      end

      render_text(source, 60, 750, "捐赠编号：#{record.certificate_no}") do |c|
        c.pointsize '20'
      end

      file_name = Encryption.md5(record.id.to_s)
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
      line.each_char { |chr| str << chr; index += (chr.ord < 129 ? 1 : 2); str << "\n" and index = 1 if index > 38 }
      str
    end.join
  end

  def self.render_content(src, message)
    formated_text = format_text(message)
    formated_text.each_line.each_with_index do |line, index|
      render_text(src, 60, 375 + index * 40, line)
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
