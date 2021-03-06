# == Schema Information
#
# Table name: project_season_applies # 项目执行年度申请表
#
#  id                   :bigint(8)        not null, primary key
#  project_id           :integer                                # 关联项目id
#  project_season_id    :integer                                # 关联项目执行年度的id
#  school_id            :integer                                # 关联学校id
#  teacher_id           :integer                                # 负责项目的老师id
#  describe             :text                                   # 描述、申请要求
#  province             :string                                 # 省
#  city                 :string                                 # 市
#  district             :string                                 # 区/县
#  state                :integer          default("show")       # 状态：1:展示 2:隐藏
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  name                 :string                                 # 名称
#  number               :integer                                # 配额
#  apply_no             :string                                 # 项目申请编号
#  bookshelf_type       :integer                                # 悦读项目申请类型
#  contact_name         :string                                 # 联系人姓名
#  contact_phone        :string                                 # 联系人电话
#  audit_state          :integer                                # 审核状态
#  abstract             :string                                 # 简述
#  address              :string                                 # 详细地址
#  girl_number          :integer                                # 申请女生人数
#  boy_number           :integer                                # 申请男生人数
#  consignee            :string                                 # 收货人
#  consignee_phone      :string                                 # 收货人联系电话
#  target_amount        :decimal(14, 2)   default(0.0)          # 目标金额
#  present_amount       :decimal(14, 2)   default(0.0)          # 目前已筹金额
#  execute_state        :integer          default(NULL)         # 执行状态：0:准备中 1:筹款中 2:待执行 3:待收货 4:待反馈 5:已完成
#  project_type         :integer          default("apply")      # 项目类型:1:申请 2:筹款项目
#  class_number         :integer                                # 申请班级数
#  student_number       :integer                                # 受益学生数
#  project_describe     :text                                   # 项目介绍
#  form                 :jsonb                                  # 自定义表单{key, value}
#  pair_state           :integer                                # 结对审核状态
#  code                 :string                                 # code
#  read_state           :integer                                # 悦读项目状态
#  camp_id              :integer                                # 探索营id
#  camp_start_time      :datetime                               # 探索营-开营时间
#  camp_period          :integer                                # 探索营-行程天数
#  camp_state           :integer                                # 探索营-项目状态
#  camp_principal       :string                                 # 探索营-营负责人
#  camp_income_source   :string                                 # 探索营-经费来源
#  inventory_state      :integer                                # 是否使用物资清单
#  applicant_id         :integer                                # 申请人id
#  management_fee_state :integer                                # 计提管理费状态
#

require 'rails_helper'

RSpec.describe ProjectSeasonApply, type: :model do
  let!(:user) { create(:user) }
  let!(:school) { create(:school, user: user) }
  let!(:teacher) { create(:teacher, school: school, user: user) }
  let!(:project) { create(:project) }
  let!(:season) { create(:project_season, project: project) }
  let!(:apply) { create(:project_season_apply, project: project, season: season, teacher: teacher, school: school) }

  it '生成申请编号' do
    expect(apply.apply_no.present?).to be true
  end

  it '测试动态表单的展示' do
    project.form = [ { "key": "name", "type": "text", "label": "姓名", "options": [], "required": "y" }, { "key": "telphone", "type": "text", "label": "电话", "options": [], "required": "y" }, { "key": "gender", "type": "select", "label": "性别", "options": [ "男", "女" ] }, { "key": "grade", "type": "select", "label": "年级", "options": [ "初一", "初二", "初三", "高一", "高二", "高三" ], "required": "y" }, { "key": "desc", "type": "textarea", "label": "说明", "options": [] } ]
    project.save
    apply.form = { "name": "王二小", "telphone": "13899998888", "gender": [ "男" ] }
    apply.save
    # pp apply.form_builder
    expect(apply.form_builder.length).to eq(project.form.length)
  end
end
