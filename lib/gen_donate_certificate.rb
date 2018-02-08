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
      render_white_text(source, 100, 460, "#{record.donation_name}项目")
      render_white_line(source, 100, 477, 350)
      render_white_text(source, 100, 520, "捐赠编号：#{record.certificate_no}")

      render_text(source, 100, 660, "感谢您！亲爱的#{name}，")
      # content = "　　感谢为支持#{project_name}项目慷慨捐赠#{number_to_currency donors.sum(&:amount)}元。谨代表受帮助的孩子向您表示最崇高敬意和衷心感谢！\n　　特颁此证，以资纪念。"
      content = "　　感谢您为支持格桑花西部助学#{record.donation_name}项目的慷慨捐赠。谨代表受帮助的孩子向您表示最崇高敬意和衷心感谢！"
      render_content(source, content)

      render_text(source, 548, 1035, Date.today.year.to_s)
      render_text(source, 608, 1035, '年')
      render_text(source, 638, 1035, Date.today.month.to_s)
      render_text(source, 660, 1035, '月')
      render_text(source, 698, 1035, Date.today.day.to_s)
      render_text(source, 720, 1035, '日')

      # # seq = "捐赠编码: WY" << Sequence.get_seq(:donor_card)
      # seq = record.certificate_no
      # render_text(source, 76, 1070, seq)

      file_name = Encryption.md5(record.id.to_s)
      rel_path = "/images/certificates/#{record.created_at.strftime('%Y%m%d')}/#{record.id}"
      path_name = Rails.root.to_s + '/public' + rel_path
      FileUtils.mkpath(path_name) unless File.directory?(path_name)
      #source.depth('8')
      source.quality('100')
      source.write(path_name + "/#{file_name}.jpg")
    end
  end

  private
  def self.format_text(text)
    text.gsub("\r\n", "\n").each_line.map do |line|
      str = ""; index = 1
      line.each_char { |chr| str << chr; index += (chr.ord < 129 ? 1 : 2); str << "\n" and index = 1 if index > 46 }
      str
    end.join
  end

  def self.render_content(src, message)
    formated_text = format_text(message)
    formated_text.each_line.each_with_index do |line, index|
      render_text(src, 100, 725 + index * 60, line)
    end
  end

  def self.render_text(src, left, top, line, &block)
    return unless line.present?
    src.combine_options do |c|
      c.font File.expand_path('..', __FILE__) + '/certificate/simsun.ttc'
      c.fill '#000'
      c.pointsize '26'
      block.call(c) if block_given?
      c.draw "text #{left},#{top} '#{line}'"
    end
  end

  def self.render_white_text(src, left, top, line, &block)
    return unless line.present?
    src.combine_options do |c|
      c.font File.expand_path('..', __FILE__) + '/certificate/simsun.ttc'
      c.fill '#fff'
      c.pointsize '26'
      block.call(c) if block_given?
      c.draw "text #{left},#{top} '#{line}'"
    end
  end

  def self.render_white_line(src, left, top, length, &block)
    src.combine_options do |c|
      # c.font File.expand_path('..', __FILE__) + '/certificate/simsun.ttc'
      c.fill '#fff'
      c.strokewidth '2'
      block.call(c) if block_given?
      c.draw "line #{left},#{top} #{left + length},#{top}"
    end
  end

end
