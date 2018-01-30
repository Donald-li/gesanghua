# == Schema Information
#
# Table name: beneficial_children
#
#  id                      :integer          not null, primary key
#  id_no                   :string                                 # 身份证号
#  name                    :string                                 # 姓名
#  gender                  :integer                                # 性别
#  nation                  :integer                                # 民族
#  gsh_bookshelf_id        :integer                                # 图书角ID
#  project_season_apply_id :integer                                # 项目申请ID
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class BeneficialChild < ApplicationRecord
  belongs_to :project_season_apply
  belongs_to :gsh_bookshelf, optional: true

  enum gender: {male: 1, female: 2}

  enum nation: {'default': 0, 'hanzu': 1, 'zhuangzu': 2, 'manzu': 3, 'huizu': 4, 'miaozu': 5, 'weizu': 6, 'tujiazu': 7, 'yizu': 8, 'mengguzu': 9, 'zangzu': 10, 'buyizu': 11, 'dongzu': 12, 'yaozu': 13, 'chaoxianzu': 14, 'baizu': 15, 'hanizu': 16, 'hasakezu': 17, 'lizu': 18, 'daizu': 19, 'shezu': 20, 'lisuzu': 21, 'gelaozu': 22, 'dongxiangzu': 23, 'gaoshanzu': 24, 'lahuzu': 25, 'shuizu': 26, 'wazu': 27, 'naxizu': 28, 'qiangzu': 29, 'tuzu': 30, 'mulaozu': 31, 'xibozu': 32, 'keerkezizu': 33, 'dawoerzu': 34, 'jingpozu': 35, 'maonanzu': 36, 'salazu': 37, 'bulangzu': 38, 'tajikezu': 39, 'achangzu': 40, 'pumizu': 41, 'ewenkezu': 42, 'nuzu': 43, 'jingzu': 44, 'jinuozu': 45, 'deangzu': 46, 'baoanzu': 47, 'eluosizu': 48, 'yuguzu': 49, 'wuzibiekezu': 50, 'menbazu': 51, 'elunchunzu': 52, 'dulongzu': 53, 'tataerzu': 54, 'hezhezu': 55, 'luobazu': 56}
  default_value_for :nation, 0

  # validates :id_no, shenfenzheng_no: true

  scope :sorted, -> {order(created_at: :desc)}

  include HasAsset
  has_one_asset :children_excel, class_name: 'Asset::BeneficialChildrenExcel'

  def self.read_excel(excel_id, apply_id, gsh_bookshelf_id)
    file = Asset.find(excel_id).try(:file).try(:file)
    FileUtil.import_beneficial_children_records(original_filename: file.original_filename, path: file.path, apply_id: apply_id, gsh_bookshelf_id: gsh_bookshelf_id) if file.present?
  end

  def self.nation_hash_name(key)
    nation_hash = {'default' => '未设置', 'hanzu' => '汉族', 'zhuangzu' => '壮族', 'manzu' => '满族', 'huizu' => '回族', 'miaozu' => '苗族', 'weizu' => '维吾尔族', 'tujiazu' => '土家族', 'yizu' => '彝族', 'mengguzu' => '蒙古族', 'zangzu' => '藏族', 'buyizu' => '布依族', 'dongzu' => '侗族', 'yaozu' => '瑶族', 'chaoxianzu' => '朝鲜族', 'baizu' => '白族', 'hanizu' => '哈尼族', 'hasakezu' => '哈萨克族', 'lizu' => '黎族', 'daizu' => '傣族', 'shezu' => '畲族', 'lisuzu' => '傈僳族', 'gelaozu' => '仡佬族', 'dongxiangzu' => '东乡族', 'gaoshanzu' => '高山族', 'lahuzu' => '拉祜族', 'shuizu' => '水族', 'wazu' => '佤族', 'naxizu' => '纳西族', 'qiangzu' => '羌族', 'tuzu' => '土族', 'mulaozu' => '仫佬族', 'xibozu' => '锡伯族', 'keerkezizu' => '柯尔克孜族', 'dawoerzu' => '达斡尔族', 'jingpozu' => '景颇族', 'maonanzu' => '毛南族', 'salazu' => '撒拉族', 'bulangzu' => '布朗族', 'tajikezu' => '塔吉克族', 'achangzu' => '阿昌族', 'pumizu' => '普米族', 'ewenkezu' => '鄂温克族', 'nuzu' => '怒族', 'jingzu' => '京族', 'jinuozu' => '基诺族', 'deangzu' => '德昂族', 'baoanzu' => '保安族', 'eluosizu' => '俄罗斯族', 'yuguzu' => '裕固族', 'wuzibiekezu' => '乌孜别克族', 'menbazu' => '门巴族', 'elunchunzu' => '鄂伦春族', 'dulongzu' => '独龙族', 'tataerzu' => '塔塔尔族', 'hezhezu' => '赫哲族', 'luobazu' => '珞巴族'}
    nation_hash.invert[key]
  end

end
