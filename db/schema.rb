# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180611074108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_records", force: :cascade, comment: "账户记录" do |t|
    t.integer "user_id", comment: "用户ID"
    t.integer "kind", comment: "操作类型"
    t.integer "income_record_id"
    t.integer "donate_record_id"
    t.integer "donor_id"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.text "remark", comment: "备注"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", comment: "标题"
    t.integer "state", comment: "类型"
  end

  create_table "adjust_records", force: :cascade, comment: "分类调整记录" do |t|
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.integer "user_id", comment: "操作人"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_item_id"
    t.string "from_item_type"
    t.string "to_item_type"
    t.integer "to_item_id"
  end

  create_table "administrator_logs", force: :cascade, comment: "管理员日志" do |t|
    t.integer "administrator_id", comment: "管理员id"
    t.integer "kind", comment: "日志动作类型，1:登录 2:登出"
    t.string "ip", comment: "ip地址"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adverts", force: :cascade, comment: "广告表" do |t|
    t.integer "kind", comment: "分类"
    t.string "title", comment: "标题"
    t.string "description", comment: "描述"
    t.string "url", comment: "链接"
    t.integer "views_count", comment: "展示次数"
    t.integer "kind_position", comment: "分类排序"
    t.integer "state", comment: "状态"
    t.integer "user_id", comment: "用户id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "amount_tabs", force: :cascade, comment: "金额选项卡表" do |t|
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.string "alias", comment: "别名"
    t.integer "state", default: 1, comment: "状态 1:显示 2:隐藏"
    t.integer "donate_item_id", comment: "可捐助id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_categories", force: :cascade, comment: "文章类别表" do |t|
    t.string "name", comment: "名称"
    t.integer "position", comment: "位置"
    t.integer "state", comment: "状态"
    t.string "describe", comment: "描述"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade, comment: "资讯表" do |t|
    t.string "title", comment: "标题"
    t.text "content", comment: "内容"
    t.integer "state", default: 1, comment: "状态, 1:展示 2:隐藏"
    t.integer "recommend", default: 0, comment: "推荐 0:正常 1:推荐"
    t.integer "article_category_id", comment: "资讯分类id"
    t.datetime "published_at", comment: "发布时间"
    t.string "author", comment: "作者"
    t.string "source", comment: "来源"
    t.text "describe", comment: "摘要"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", comment: "类型"
    t.integer "special_kind", comment: "专题类型： 1:文字新闻 2:图片新闻"
  end

  create_table "assets", force: :cascade, comment: "资源表" do |t|
    t.string "type"
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "position"
    t.string "file"
    t.string "file_name"
    t.integer "file_size"
    t.integer "width"
    t.integer "height"
    t.string "user_type"
    t.integer "user_id"
    t.string "protect_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_assets_on_type"
  end

  create_table "audits", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.integer "state", comment: "审核状态 0:待审核 1:通过 2:未通过"
    t.integer "user_id", comment: "审核人"
    t.text "comment", comment: "评语"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_audits_on_owner_type_and_owner_id"
  end

  create_table "badge_levels", force: :cascade, comment: "勋章级别" do |t|
    t.integer "kind", comment: "类型"
    t.string "title", comment: "标题"
    t.integer "position", comment: "排序"
    t.integer "value", comment: "获得条件"
    t.string "rank", comment: "级别描述"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_level", default: false, comment: "默认徽章"
    t.string "description", comment: "徽章描述"
  end

  create_table "beneficial_children", force: :cascade do |t|
    t.string "id_no", comment: "身份证号"
    t.string "name", comment: "姓名"
    t.integer "gender", comment: "性别"
    t.integer "nation", comment: "民族"
    t.integer "project_season_apply_id", comment: "项目申请ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_apply_bookshelf_id", comment: "书架id"
  end

  create_table "bookshelf_supplements", force: :cascade do |t|
    t.integer "project_season_apply_bookshelf_id", comment: "书架ID"
    t.integer "project_season_apply_id", comment: "申请ID"
    t.integer "loss", comment: "损耗数量"
    t.integer "state", comment: "审核状态"
    t.text "describe", comment: "描述"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "present_amount", precision: 14, scale: 2, default: "0.0", comment: "目前已筹金额"
    t.integer "supply", comment: "补充数量"
    t.decimal "target_amount", precision: 14, scale: 2, default: "0.0", comment: "目标金额"
    t.integer "audit_state", comment: "审核状态"
    t.integer "show_state", comment: "显示状态"
    t.integer "project_id", comment: "项目id"
    t.integer "management_fee_state", comment: "计提管理费状态"
    t.index ["audit_state"], name: "index_bookshelf_supplements_on_audit_state"
    t.index ["project_season_apply_bookshelf_id"], name: "index_bookshelf_supplements_on_bookshelf_id"
    t.index ["project_season_apply_id"], name: "index_bookshelf_supplements_on_project_season_apply_id"
    t.index ["state"], name: "index_bookshelf_supplements_on_state"
  end

  create_table "camp_document_estimates", force: :cascade, comment: "拓展营概算表" do |t|
    t.integer "user_id", comment: "用户"
    t.string "item", comment: "项"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.string "remark", comment: "备注"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_apply_id", comment: "探索营申请id"
    t.integer "camp_id", comment: "探索营id"
  end

  create_table "camp_document_finances", force: :cascade, comment: "拓展营预决算表" do |t|
    t.integer "user_id", comment: "用户"
    t.string "item", comment: "项"
    t.decimal "budge", precision: 14, scale: 2, default: "0.0", comment: "预算"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "决算"
    t.string "remark", comment: "备注"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_apply_id", comment: "探索营申请id"
    t.integer "camp_id", comment: "探索营id"
  end

  create_table "camp_document_summaries", force: :cascade, comment: "拓展营总结" do |t|
    t.integer "user_id", comment: "用户"
    t.string "free_resource", comment: "本营免费资源"
    t.decimal "resource_value", precision: 14, scale: 2, default: "0.0", comment: "免费资源价值"
    t.decimal "donate_amount", precision: 14, scale: 2, default: "0.0", comment: "本营筹款多少"
    t.integer "publicize_count", comment: "本营宣传次数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_apply_id", comment: "探索营申请id"
    t.integer "camp_id", comment: "探索营id"
  end

  create_table "camp_document_volunteers", force: :cascade, comment: "拓展营志愿者表" do |t|
    t.integer "user_id", comment: "用户"
    t.integer "volunteer_id", comment: "志愿者"
    t.string "remark", comment: "营备注"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_apply_id", comment: "探索营申请id"
    t.integer "camp_id", comment: "探索营id"
  end

  create_table "camp_project_resources", force: :cascade, comment: "拓展营资源表" do |t|
    t.integer "user_id", comment: "用户"
    t.string "company", comment: "单位名称"
    t.string "resource", comment: "资源名称"
    t.string "contact_name", comment: "联系人"
    t.string "contact_phone", comment: "联系人电话"
    t.string "gsh_contact_name", comment: "格桑花联系人"
    t.string "gsh_contact_phone", comment: "格桑花联系人电话"
    t.string "remark", comment: "资源说明"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "camp_id", comment: "探索营id"
  end

  create_table "campaign_categories", force: :cascade, comment: "活动分类表" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaign_enlists", force: :cascade, comment: "活动报名表" do |t|
    t.integer "campaign_id", comment: "活动ID"
    t.integer "user_id", comment: "用户ID"
    t.integer "number", comment: "报名人数"
    t.string "remark", comment: "备注"
    t.decimal "total", precision: 14, scale: 2, default: "0.0", comment: "合计报名金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_name", comment: "联系人"
    t.string "contact_phone", comment: "联系电话"
    t.integer "payment_state", default: 1, comment: "支付状态 1:已支付 2:已取消"
    t.integer "income_source_id", comment: "收入来源id"
    t.jsonb "form", comment: "报名表单"
    t.index ["campaign_id"], name: "index_campaign_enlists_on_campaign_id"
  end

  create_table "campaigns", force: :cascade, comment: "活动表" do |t|
    t.string "name", comment: "名称"
    t.decimal "price", precision: 14, scale: 2, default: "0.0", comment: "报名费"
    t.text "content", comment: "内容"
    t.datetime "start_time", comment: "预计开始时间"
    t.datetime "end_time", comment: "预计结束时间"
    t.datetime "sign_up_end_time", comment: "报名截止时间"
    t.integer "state", default: 1, comment: "状态，1：展示 2：隐藏"
    t.integer "project_id", comment: "关联项目ID"
    t.integer "campaign_category_id", comment: "活动分类ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sign_up_start_time", comment: "报名开始时间"
    t.integer "number", comment: "报名限制人数"
    t.string "remark", comment: "报名表备注"
    t.jsonb "form", comment: "报名表单定义"
    t.integer "execute_state", comment: "执行状态"
    t.integer "appoint_fund_id", comment: "指定财务分类"
  end

  create_table "camps", force: :cascade, comment: "探索营" do |t|
    t.string "name", comment: "名称"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区、县"
    t.integer "fund_id", comment: "资金id"
    t.integer "state", comment: "状态：1:启用 2:禁用）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manager", comment: "负责人"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "complaints", force: :cascade, comment: "举报表" do |t|
    t.string "contact_name", comment: "联系人姓名"
    t.string "contact_phone", comment: "联系人手机"
    t.text "content", comment: "举报详情"
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "state", comment: "处理状态： 1:submit 2:check"
    t.text "remark", comment: "处理备注"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "county_users", force: :cascade do |t|
    t.string "name", comment: "姓名"
    t.string "phone", comment: "联系方式"
    t.string "unit_name", comment: "单位名称"
    t.string "unit_describe", comment: "单位简介"
    t.integer "user_id", comment: "用户id"
    t.string "address", comment: "详细地址"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "duty", comment: "职务"
  end

  create_table "cross_fund_adjustments", force: :cascade do |t|
    t.integer "kind", comment: "类型：1:平台 2:配捐 3:退款"
    t.integer "from_fund_id", comment: "被调整分类"
    t.integer "to_fund_id", comment: "调整到分类"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "调整金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donate_items", force: :cascade, comment: "可捐助项目表" do |t|
    t.string "name", comment: "名称"
    t.string "describe", comment: "说明"
    t.integer "state", comment: "状态： 1：显示 2：隐藏"
    t.integer "position", comment: "排序"
    t.integer "fund_id", comment: "基金id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donate_records", force: :cascade, comment: "捐赠记录" do |t|
    t.integer "donor_id", comment: "用户id"
    t.integer "fund_id", comment: "基金ID"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "捐助金额"
    t.integer "project_id", comment: "项目id"
    t.integer "team_id", comment: "小组id"
    t.integer "promoter_id", comment: "劝捐人"
    t.integer "agent_id", comment: "汇款人id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_id", comment: "年度ID"
    t.integer "project_season_apply_id", comment: "年度项目ID"
    t.integer "gsh_child_id", comment: "格桑花孩子id"
    t.integer "income_record_id", comment: "收入记录"
    t.string "title", comment: "捐赠标题"
    t.string "source_type"
    t.bigint "source_id", comment: "资金来源"
    t.string "owner_type"
    t.bigint "owner_id", comment: "捐助所属捐助项"
    t.integer "donation_id", comment: "捐助id"
    t.integer "kind", comment: "捐助方式 1:捐款 2:配捐"
    t.integer "project_season_apply_child_id", comment: "一对一孩子"
    t.integer "state", comment: "状态"
    t.integer "school_id", comment: "学校id"
    t.jsonb "archive_data", comment: "归档旧数据"
    t.index ["donation_id"], name: "index_donate_records_on_donation_id"
    t.index ["donor_id"], name: "index_donate_records_on_donor_id"
    t.index ["gsh_child_id"], name: "index_donate_records_on_gsh_child_id"
    t.index ["owner_type", "owner_id"], name: "index_donate_records_on_owner_type_and_owner_id"
    t.index ["project_id"], name: "index_donate_records_on_project_id"
    t.index ["project_season_apply_child_id"], name: "index_donate_records_on_apply_child_id"
    t.index ["project_season_apply_id"], name: "index_donate_records_on_apply_id"
    t.index ["source_type", "source_id"], name: "index_donate_records_on_source_type_and_source_id"
  end

  create_table "donations", force: :cascade, comment: "捐助表" do |t|
    t.integer "donor_id", comment: "捐助人id"
    t.string "owner_type"
    t.bigint "owner_id", comment: "捐助所属模型"
    t.integer "pay_state", comment: "支付状态"
    t.integer "project_id", comment: "项目id"
    t.integer "project_season_id", comment: "批次/年度id"
    t.integer "project_season_apply_id", comment: "申请id"
    t.string "order_no", comment: "订单编号"
    t.string "title", comment: "标题"
    t.integer "promoter_id", comment: "劝捐人"
    t.integer "team_id", comment: "团队id"
    t.text "pay_result", comment: "支付接口返回的支付接口数据"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "details", comment: "捐助详情"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "捐助金额"
    t.integer "agent_id", comment: "代理人id"
    t.integer "pay_way", comment: "支付方式"
    t.index ["donor_id"], name: "index_donations_on_donor_id"
    t.index ["owner_type", "owner_id"], name: "index_donations_on_owner_type_and_owner_id"
    t.index ["pay_state"], name: "index_donations_on_pay_state"
    t.index ["project_id"], name: "index_donations_on_project_id"
    t.index ["project_season_apply_id"], name: "index_donations_on_project_season_apply_id"
    t.index ["team_id"], name: "index_donations_on_team_id"
  end

  create_table "exception_records", force: :cascade do |t|
    t.string "title", comment: "标题"
    t.string "content", comment: "内容"
    t.string "schedule", comment: "进度更新"
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "user_id", comment: "提交人id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenditure_ledgers", force: :cascade, comment: "支出分类" do |t|
    t.string "name", comment: "名称"
    t.integer "position", comment: "排序"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "合计支出金额"
    t.text "describe", comment: "描述"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenditure_records", force: :cascade, comment: "支出记录表" do |t|
    t.integer "fund_id", comment: "基金ID"
    t.string "appoint_type", comment: "指定类型"
    t.integer "appoint_id", comment: "指定类型id"
    t.integer "administrator_id", comment: "管理员id"
    t.integer "income_record_id", comment: "入账记录id"
    t.integer "deliver_state", comment: "发放状态"
    t.integer "kind", comment: "类别"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", comment: "支出名称"
    t.string "expend_no", comment: "支出编号"
    t.datetime "expended_at", comment: "支出时间"
    t.string "operator", comment: "支出经办人"
    t.text "remark", comment: "备注"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "支出金额"
    t.integer "expenditure_ledger_id"
    t.integer "income_source_id"
  end

  create_table "family_members", force: :cascade, comment: "家庭成员表" do |t|
    t.integer "visit_id", comment: "家访表ID"
    t.string "name", comment: "成员姓名"
    t.integer "age", comment: "年龄"
    t.string "relationship", comment: "关系"
    t.string "profession", comment: "职业"
    t.text "health_condition", comment: "健康状况"
    t.text "job_condition", comment: "工作情况"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade, comment: "反馈表" do |t|
    t.text "content", comment: "内容"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "type", comment: "类型：receive、install、continual"
    t.integer "state", comment: "状态"
    t.integer "approve_state", comment: "审核状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", comment: "反馈类型"
    t.integer "check", comment: "查看 1: 未查看 2: 已查看"
    t.integer "recommend", comment: "推荐 1: 正常 2: 推荐"
    t.integer "user_id", comment: "反馈人"
    t.integer "project_id", comment: "项目id"
    t.integer "project_season_id", comment: "批次id"
    t.integer "project_season_apply_id", comment: "申请id"
    t.integer "project_season_apply_child_id", comment: "孩子id"
    t.integer "project_season_apply_bookshelf_id", comment: "书架id"
    t.string "class_name", comment: "反馈班级"
    t.integer "gsh_child_grant_id", comment: "学生某学期的持续反馈（感谢信）"
    t.integer "school_id", comment: "学校id"
    t.datetime "arise_at", comment: "开展时间"
    t.string "arise_class", comment: "开展班级"
    t.integer "number", comment: "参与人数"
  end

  create_table "fund_categories", force: :cascade do |t|
    t.string "name", comment: "分类名"
    t.integer "position", comment: "排序"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.decimal "total", precision: 14, scale: 2, default: "0.0", comment: "历史收入"
    t.string "describe", comment: "简介"
    t.integer "state", default: 1, comment: "状态 1:显示 2:隐藏"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 1, comment: "类型 1:非定向 2:定向"
  end

  create_table "funds", force: :cascade do |t|
    t.string "name", comment: "基金名"
    t.integer "position", comment: "排序"
    t.decimal "balance", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.decimal "total", precision: 14, scale: 2, default: "0.0", comment: "历史收入"
    t.integer "management_rate", default: 0, comment: "管理费率"
    t.string "describe", comment: "简介"
    t.integer "state", default: 1, comment: "状态 1:显示 2:隐藏"
    t.bigint "fund_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 1, comment: "类型 1:非定向 2:定向"
    t.integer "use_kind", default: 1, comment: "指定类型 1:非指定 2:指定"
    t.decimal "out_total", precision: 14, scale: 2, default: "0.0", comment: "历史支出"
    t.index ["fund_category_id"], name: "index_funds_on_fund_category_id"
  end

  create_table "goods_categories", force: :cascade, comment: "物资分类" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grant_batches", force: :cascade, comment: "发放批次" do |t|
    t.integer "project_id", comment: "所属项目"
    t.string "batch_no", comment: "批次号"
    t.string "name", comment: "名称"
    t.text "description", comment: "描述"
    t.integer "state", comment: "状态"
    t.integer "user_id", comment: "发放负责人"
    t.datetime "grant_at", comment: "发放时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gsh_child_grants", force: :cascade, comment: "格桑花孩子发放表" do |t|
    t.bigint "gsh_child_id", comment: "关联孩子表id"
    t.bigint "project_season_apply_id", comment: "关联申请表"
    t.integer "state", comment: "状态 1:为筹款 2:待发放 3:发放完成"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "发放金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "school_id", comment: "学校ID"
    t.integer "project_season_id", comment: "批次ID"
    t.integer "donate_state", comment: "捐助状态"
    t.string "grant_no", comment: "格桑花发放编号"
    t.datetime "granted_at", comment: "发放时间"
    t.text "grant_remark", comment: "发放说明"
    t.string "delay_reason", comment: "暂缓发放原因"
    t.text "delay_remark", comment: "暂缓发放备注"
    t.integer "balance_manage", comment: "取消余额处理"
    t.text "cancel_remark", comment: "取消说明"
    t.string "title", comment: "标题"
    t.text "remark"
    t.integer "operator_id", comment: "异常处理人id"
    t.string "grant_person", comment: "发放人"
    t.integer "user_id", comment: "捐助人"
    t.integer "grant_batch_id", comment: "发放批次"
    t.integer "project_season_apply_child_id", comment: "一对一助学孩子id"
    t.integer "cancel_reason", comment: "取消原因"
    t.integer "management_fee_state", comment: "计提管理费状态"
    t.index ["donate_state"], name: "index_gsh_child_grants_on_donate_state"
    t.index ["grant_batch_id"], name: "index_gsh_child_grants_on_grant_batch_id"
    t.index ["gsh_child_id"], name: "index_gsh_child_grants_on_gsh_child_id"
    t.index ["project_season_apply_child_id"], name: "index_gsh_child_grants_on_apply_child_id"
    t.index ["project_season_apply_id"], name: "index_gsh_child_grants_on_project_season_apply_id"
    t.index ["state"], name: "index_gsh_child_grants_on_state"
  end

  create_table "gsh_children", force: :cascade, comment: "格桑花孩子表" do |t|
    t.string "name", comment: "孩子姓名"
    t.integer "kind", comment: "类型"
    t.string "workstation", comment: "工作地点"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.string "gsh_no", comment: "格桑花孩子编号"
    t.string "phone", comment: "联系电话"
    t.string "qq", comment: "qq号"
    t.integer "user_id", comment: "关联用户id"
    t.string "id_card", comment: "身份证"
    t.integer "semester_count", default: 0, comment: "孩子申请学期总数"
    t.integer "done_semester_count", default: 0, comment: "孩子募款成功学期总数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "income_records", force: :cascade, comment: "入帐记录表" do |t|
    t.integer "donor_id", comment: "用户id"
    t.integer "fund_id", comment: "基金ID"
    t.integer "income_source_id", comment: "来源id"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "入账金额"
    t.decimal "balance", precision: 14, scale: 2, default: "0.0", comment: "余额"
    t.integer "agent_id", comment: "汇款人id"
    t.integer "promoter_id", comment: "劝捐人"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "income_time", comment: "入账时间"
    t.text "remark", comment: "备注"
    t.integer "voucher_state", comment: "开票状态"
    t.string "title", comment: "收入名称"
    t.integer "donation_id", comment: "捐助id"
    t.integer "kind", comment: "来源: 1:线上 2:线下"
    t.integer "team_id", comment: "团队id"
    t.integer "voucher_id", comment: "捐赠收据ID"
    t.string "certificate_no", comment: "捐赠证书编号"
    t.string "income_no", comment: "收入编号"
    t.jsonb "archive_data", comment: "归档旧数据"
    t.index ["agent_id"], name: "index_income_records_on_agent_id"
    t.index ["donation_id"], name: "index_income_records_on_donation_id"
    t.index ["donor_id"], name: "index_income_records_on_donor_id"
    t.index ["team_id"], name: "index_income_records_on_team_id"
    t.index ["voucher_state"], name: "index_income_records_on_voucher_state"
  end

  create_table "income_sources", force: :cascade, comment: "收入来源" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", comment: "描述"
    t.integer "position", comment: "位置"
    t.integer "kind", comment: "类型： 1:线上（online） 2:线下（offline）"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "累计收入"
    t.decimal "in_total", precision: 14, scale: 2, default: "0.0", comment: "历史收入"
    t.decimal "out_total", precision: 14, scale: 2, default: "0.0", comment: "历史支出"
  end

  create_table "logistics", force: :cascade, comment: "物流表" do |t|
    t.integer "name", comment: "物流公司 1:顺丰"
    t.string "number", comment: "物流单号"
    t.string "owner_type"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "majors", force: :cascade, comment: "专业表" do |t|
    t.string "name", comment: "专业名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "management_fee_months", force: :cascade, comment: "管理费提取" do |t|
    t.string "month", comment: "月份"
    t.integer "count", default: 0, comment: "项目数"
    t.decimal "fee", precision: 14, scale: 2, default: "0.0", comment: "管理费"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "management_fees", force: :cascade, comment: "管理费" do |t|
    t.string "owner_type", comment: "所属项目"
    t.integer "owner_id", comment: "所属项目ID"
    t.decimal "total_amount", precision: 14, scale: 2, default: "0.0", comment: "项目金额"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "提取管理费金额"
    t.integer "fund_id", comment: "收入分类"
    t.float "rate", comment: "费率"
    t.decimal "fee", precision: 14, scale: 2, default: "0.0", comment: "管理费金额"
    t.integer "user_id", comment: "用户"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "month_id", comment: "月份"
  end

  create_table "month_donates", force: :cascade, comment: "月捐表" do |t|
    t.integer "user_id", comment: "用户id"
    t.integer "fund_id", comment: "基金id"
    t.integer "plan_period", comment: "计划期数"
    t.integer "donated_period", comment: "已捐期数"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "每期捐助金额"
    t.datetime "start_time", comment: "开始时间"
    t.integer "state", comment: "捐助状态 1:捐助中 2:已结束"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id", comment: "项目ID"
    t.string "certificate_no", comment: "捐赠证书编号"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "push_type", comment: "bit_enum，邮件、短信、微信"
    t.string "kind", comment: "类型，通知类型"
    t.integer "from_user_id", comment: "发起用户"
    t.integer "user_id", comment: "通知用户"
    t.integer "project_id", comment: "项目"
    t.integer "project_season_id", comment: "批次"
    t.integer "project_season_apply_id", comment: "申请"
    t.string "owner_type"
    t.integer "owner_id"
    t.text "content", comment: "内容"
    t.boolean "read", comment: "是否已读"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", comment: "消息标题"
  end

  create_table "pages", force: :cascade, comment: "单页面" do |t|
    t.string "title", comment: "标题"
    t.string "alias", comment: "别名"
    t.text "content", comment: "内容"
    t.integer "position", comment: "排序"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partners", force: :cascade, comment: "合作伙伴" do |t|
    t.string "name", comment: "名称"
    t.string "url", comment: "链接"
    t.integer "position", comment: "排序"
    t.integer "state", comment: "状态： 1:显示 2:隐藏"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "period_child_ships", force: :cascade, comment: "年度孩子和申请学期中间表" do |t|
    t.integer "project_season_apply_period_id", comment: "申请学期ID"
    t.integer "project_season_apply_child_id", comment: "年度孩子ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_reports", force: :cascade, comment: "项目报告表" do |t|
    t.string "title", comment: "标题"
    t.text "content", comment: "内容"
    t.integer "state", comment: "状态：1显示 2隐藏"
    t.integer "project_id", comment: "项目id"
    t.datetime "published_at", comment: "发布时间"
    t.integer "kind", comment: "类型: 1项目报告 2回访报告"
    t.integer "position", comment: "位置"
    t.integer "user_id", comment: "发布人"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_season_applies", force: :cascade, comment: "项目执行年度申请表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度的id"
    t.integer "school_id", comment: "关联学校id"
    t.integer "teacher_id", comment: "负责项目的老师id"
    t.text "describe", comment: "描述、申请要求"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.integer "state", default: 1, comment: "状态：1:展示 2:隐藏"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", comment: "名称"
    t.integer "number", comment: "配额"
    t.string "apply_no", comment: "项目申请编号"
    t.integer "bookshelf_type", comment: "悦读项目申请类型"
    t.string "contact_name", comment: "联系人姓名"
    t.string "contact_phone", comment: "联系人电话"
    t.integer "audit_state", comment: "审核状态"
    t.string "abstract", comment: "简述"
    t.string "address", comment: "详细地址"
    t.integer "girl_number", comment: "申请女生人数"
    t.integer "boy_number", comment: "申请男生人数"
    t.string "consignee", comment: "收货人"
    t.string "consignee_phone", comment: "收货人联系电话"
    t.decimal "target_amount", precision: 14, scale: 2, default: "0.0", comment: "目标金额"
    t.decimal "present_amount", precision: 14, scale: 2, default: "0.0", comment: "目前已筹金额"
    t.integer "execute_state", default: 0, comment: "执行状态：0:准备中 1:筹款中 2:待执行 3:待收货 4:待反馈 5:已完成"
    t.integer "project_type", default: 1, comment: "项目类型:1:申请 2:筹款项目"
    t.integer "class_number", comment: "申请班级数"
    t.integer "student_number", comment: "受益学生数"
    t.text "project_describe", comment: "项目介绍"
    t.jsonb "form", comment: "自定义表单{key, value}"
    t.integer "pair_state", comment: "结对审核状态"
    t.string "code", comment: "code"
    t.integer "read_state", comment: "悦读项目状态"
    t.integer "camp_id", comment: "探索营id"
    t.datetime "camp_start_time", comment: "探索营-开营时间"
    t.integer "camp_period", comment: "探索营-行程天数"
    t.integer "camp_state", comment: "探索营-项目状态"
    t.string "camp_principal", comment: "探索营-营负责人"
    t.string "camp_income_source", comment: "探索营-经费来源"
    t.integer "inventory_state", comment: "是否使用物资清单"
    t.integer "applicant_id", comment: "申请人id"
    t.integer "management_fee_state", comment: "计提管理费状态"
    t.index ["audit_state"], name: "index_project_season_applies_on_audit_state"
    t.index ["camp_state"], name: "index_project_season_applies_on_camp_state"
    t.index ["execute_state"], name: "index_project_season_applies_on_execute_state"
    t.index ["pair_state"], name: "index_project_season_applies_on_pair_state"
    t.index ["project_id"], name: "index_project_season_applies_on_project_id"
    t.index ["read_state"], name: "index_project_season_applies_on_read_state"
    t.index ["school_id"], name: "index_project_season_applies_on_school_id"
    t.index ["teacher_id"], name: "index_project_season_applies_on_teacher_id"
  end

  create_table "project_season_apply_bookshelves", force: :cascade, comment: "项目执行年度申请书架表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度id"
    t.integer "project_season_apply_id", comment: "关联项目执行年度申请id"
    t.string "classname", comment: "班级名"
    t.string "title", comment: "冠名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "school_id", comment: "学校id"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.integer "audit_state", comment: "审核状态 1:提交 2:通过 3:拒绝"
    t.integer "show_state", comment: "显示状态 1:显示 2:隐藏"
    t.integer "state", comment: "筹款状态:"
    t.integer "grade", comment: "年级"
    t.string "bookshelf_no", comment: "图书角编号"
    t.decimal "target_amount", precision: 14, scale: 2, default: "0.0", comment: "目标金额"
    t.decimal "present_amount", precision: 14, scale: 2, default: "0.0", comment: "目前已筹金额"
    t.integer "book_number", comment: "书籍数量"
    t.integer "student_number", comment: "班级人数"
    t.string "contact_name", comment: "联系人"
    t.string "contact_phone", comment: "联系电话"
    t.string "address", comment: "详细地址"
    t.integer "management_fee_state", comment: "计提管理费状态"
    t.index ["audit_state"], name: "index_project_season_apply_bookshelves_on_audit_state"
    t.index ["project_season_apply_id"], name: "index_bookshelves_on_apply_id"
    t.index ["state"], name: "index_project_season_apply_bookshelves_on_state"
  end

  create_table "project_season_apply_camp_members", force: :cascade do |t|
    t.string "name", comment: "姓名"
    t.string "id_card", comment: "身份证号"
    t.integer "nation", comment: "民族"
    t.integer "gender", comment: "性别"
    t.integer "school_id", comment: "学校id"
    t.integer "project_season_apply_camp_id", comment: "探索营配额id"
    t.integer "camp_id", comment: "探索营id"
    t.integer "project_season_apply_id", comment: "营立项id"
    t.integer "grade", comment: "年级"
    t.integer "level", comment: "初高中"
    t.string "teacher_name", comment: "老师姓名"
    t.string "teacher_phone", comment: "老师联系方式"
    t.string "guardian_name", comment: "监护人姓名"
    t.string "guardian_phone", comment: "监护人联系方式"
    t.text "description", comment: "自我介绍"
    t.string "reason", comment: "推荐理由"
    t.integer "state", comment: "状态"
    t.integer "age", comment: "年龄"
    t.integer "kind", comment: "类型 1学生 2老师"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone", comment: "联系方式（老师角色）"
    t.string "classname", comment: "年级"
  end

  create_table "project_season_apply_camps", force: :cascade, comment: "探索营配额" do |t|
    t.integer "project_season_apply_id", comment: "营立项id"
    t.integer "camp_id", comment: "探索营id"
    t.integer "school_id", comment: "学校id"
    t.text "describe", comment: "申请要求"
    t.integer "student_number", comment: "学生数量"
    t.integer "teacher_number", comment: "陪同老师数量"
    t.datetime "end_time", comment: "申请截止时间"
    t.integer "time_limit", comment: "是否设置截止时间"
    t.integer "message_type", comment: "通知方式"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "execute_state"
    t.string "contact_name"
    t.string "contact_phone"
    t.index ["execute_state"], name: "index_project_season_apply_camps_on_execute_state"
    t.index ["project_season_apply_id"], name: "index_apply_camps_on_apply_id"
  end

  create_table "project_season_apply_children", force: :cascade, comment: "项目执行年度申请的孩子表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度id"
    t.integer "project_season_apply_id", comment: "关联项目执行年度申请id"
    t.integer "gsh_child_id", comment: "关联格桑花孩子表id"
    t.string "name", comment: "孩子姓名"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone", comment: "电话"
    t.string "qq", comment: "QQ号码"
    t.integer "nation", comment: "民族"
    t.string "id_card", comment: "身份证号码"
    t.string "parent_name", comment: "家长姓名"
    t.text "description", comment: "描述"
    t.integer "state", comment: "状态"
    t.integer "approve_state", comment: "审核状态"
    t.integer "age", comment: "年龄"
    t.integer "level", comment: "初中或高中"
    t.integer "grade", comment: "年级"
    t.integer "gender", comment: "性别"
    t.integer "school_id", comment: "学校ID"
    t.integer "semester", comment: "学期"
    t.integer "kind", comment: "捐助形式：1对外捐助 2内部认捐"
    t.integer "donate_user_id", comment: "捐助人id"
    t.string "reason", comment: "结对申请理由"
    t.string "gsh_no", comment: "格桑花孩子编号"
    t.integer "semester_count", comment: "学期数"
    t.integer "done_semester_count", default: 0, comment: "已完成的学期数"
    t.integer "user_id", comment: "关联的用户ID"
    t.string "teacher_name", comment: "班主任"
    t.string "father", comment: "父亲"
    t.string "father_job", comment: "父亲职业"
    t.string "mother", comment: "母亲"
    t.string "mother_job", comment: "母亲职业"
    t.string "guardian", comment: "监护人"
    t.string "guardian_relation", comment: "与监护人关系"
    t.string "guardian_phone", comment: "监护人电话"
    t.string "address", comment: "家庭住址"
    t.decimal "family_income", precision: 14, scale: 2, default: "0.0", comment: "家庭年收入"
    t.decimal "family_expenditure", precision: 14, scale: 2, default: "0.0", comment: "家庭年支出"
    t.string "income_source", comment: "收入来源"
    t.string "family_condition", comment: "家庭情况"
    t.string "brothers", comment: "兄弟姐妹"
    t.string "teacher_phone", comment: "班主任联系方式"
    t.text "remark", comment: "备注"
    t.text "expenditure_information", comment: "支出详情"
    t.text "debt_information", comment: "负债情况"
    t.string "parent_information", comment: "父母情况"
    t.text "information", comment: "对外展示的孩子介绍"
    t.string "classname", comment: "班级名称"
    t.integer "priority_id", comment: "优先捐助人id"
    t.jsonb "archive_data", comment: "归档旧数据"
  end

  create_table "project_season_apply_gooods", force: :cascade, comment: "项目执行年度申请的物品表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度id"
    t.integer "project_season_apply_id", comment: "关联项目执行年度申请id"
    t.integer "project_season_goods_id", comment: "关联项目执行年度物品id"
    t.integer "num", comment: "物品申请数量"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_season_apply_inventories", force: :cascade, comment: "筹款项目物资清单" do |t|
    t.integer "project_season_apply_id", comment: "项目id"
    t.string "name", comment: "名称"
    t.decimal "unit", precision: 14, scale: 2, default: "0.0", comment: "单价（元）"
    t.integer "number", comment: "数量"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_season_apply_periods", force: :cascade, comment: "项目申请时长" do |t|
    t.string "name", comment: "名称"
    t.integer "kind", comment: "类型"
    t.integer "state", comment: "状态"
    t.string "desciption", comment: "描述"
    t.datetime "start_at", comment: "开始时间"
    t.datetime "end_at", comment: "结束时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_id", comment: "年度ID"
    t.integer "position", comment: "位置"
    t.integer "grade", comment: "一对一对应年级"
    t.integer "semester", comment: "一对一对应学期"
  end

  create_table "project_season_apply_volunteers", force: :cascade, comment: "项目执行年度申请和志愿者关联表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度id"
    t.integer "project_season_apply_id", comment: "关联项目执行年度的申请id"
    t.integer "volunteer_id", comment: "关联志愿者id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_season_goods", force: :cascade, comment: "物资类项目，执行年度的物品表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联执行年度id"
    t.string "name", comment: "物品名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_seasons", force: :cascade, comment: "项目执行年度表" do |t|
    t.integer "project_id", comment: "关联项目表id"
    t.string "name", comment: "执行年度名称"
    t.integer "state", comment: "状态 1:未执行 2:执行中"
    t.decimal "junior_term_amount", precision: 14, scale: 2, default: "0.0", comment: "初中资助金额（学期）"
    t.decimal "junior_year_amount", precision: 14, scale: 2, default: "0.0", comment: "初中资助金额（学年）"
    t.decimal "senior_term_amount", precision: 14, scale: 2, default: "0.0", comment: "高中资助金额（学期）"
    t.decimal "senior_year_amount", precision: 14, scale: 2, default: "0.0", comment: "高中资助金额（学年）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "bookshelf_univalence", precision: 14, scale: 2, default: "0.0", comment: "单个图书角金额"
  end

  create_table "projects", force: :cascade do |t|
    t.string "type", comment: "单表继承字段"
    t.integer "kind", comment: "项目类型 1:固定项目 2:物资类项目"
    t.string "name", comment: "项目名称"
    t.text "describe", comment: "简介"
    t.text "protocol", comment: "用户协议"
    t.integer "fund_id", comment: "关联财务分类id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_amount", precision: 14, scale: 2, default: "0.0", comment: "累计捐助金额"
    t.string "alias", comment: "项目别名，使用英文"
    t.integer "appoint_fund_id", comment: "定向指定财务分类id"
    t.integer "position", comment: "位置排序"
    t.jsonb "form", comment: "自定义表单{key, label, type, options, required}"
    t.integer "donate_item_id", comment: "捐助项id"
    t.integer "accept_feedback_state", comment: "是否接受定期反馈：1:open_feedback 2:close_feedback"
    t.integer "feedback_period", comment: "建议定期反馈次数/年"
    t.integer "apply_kind", default: 1, comment: "申请类型 1:平台分配 2:用户申请"
    t.integer "feedback_format", comment: "反馈形式"
    t.integer "management_rate"
  end

  create_table "protocols", force: :cascade, comment: "协议" do |t|
    t.integer "kind", comment: "类型"
    t.string "title", comment: "标题"
    t.text "content", comment: "内容"
    t.string "version", comment: "版本"
    t.integer "project_id", comment: "关联项目id"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remarks", force: :cascade, comment: "备注信息表" do |t|
    t.text "content", comment: "内容"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "operator_type", comment: "操作类型"
    t.integer "operator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade, comment: "报告表" do |t|
    t.string "title", comment: "标题"
    t.text "content", comment: "内容"
    t.string "type", comment: "单表：audit_report、financial_report、project_report"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id", comment: "项目ID"
    t.datetime "published_at", comment: "发布时间"
    t.integer "position", comment: "位置"
    t.integer "user_id", comment: "发布人"
  end

  create_table "schools", force: :cascade, comment: "学校表" do |t|
    t.string "name", comment: "学校名称"
    t.string "address", comment: "地址"
    t.integer "approve_state", default: 1, comment: "审核状态：1:待审核 2:通过 3:不通过"
    t.text "approve_remark", comment: "审核备注"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.integer "number", comment: "学校人数"
    t.text "describe", comment: "学校简介"
    t.integer "state", default: 1, comment: "学校状态：1:启用 2:禁用"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", comment: "学校等级： 1:初中 2:高中"
    t.string "contact_name", comment: "联系人"
    t.string "contact_phone", comment: "联系方式"
    t.string "contact_position", comment: "联系人职务"
    t.integer "kind", comment: "学校类型"
    t.integer "user_id", comment: "校长ID"
    t.string "school_no", comment: "学校申请编号"
    t.string "contact_id_card", comment: "联系人身份证号"
    t.string "postcode", comment: "邮政编码"
    t.integer "teacher_count", comment: "教师人数"
    t.integer "logistic_count", comment: "后勤人数"
    t.string "contact_telephone", comment: "联系人座机号码"
    t.integer "creater_id", comment: "申请人ID"
    t.integer "total_amount", comment: "累计获捐"
    t.jsonb "archive_data", comment: "归档旧数据"
  end

  create_table "sequences", force: :cascade do |t|
    t.string "kind"
    t.string "prefix"
    t.bigint "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_sequences_on_kind"
  end

  create_table "sms_codes", force: :cascade do |t|
    t.integer "kind"
    t.string "mobile"
    t.string "code"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_sms_codes_on_kind"
    t.index ["mobile"], name: "index_sms_codes_on_mobile"
  end

  create_table "special_adverts", force: :cascade do |t|
    t.integer "special_id", comment: "专题id"
    t.integer "advert_id", comment: "广告id"
    t.integer "position", comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", comment: "类型"
  end

  create_table "special_articles", force: :cascade, comment: "专题资讯表" do |t|
    t.integer "special_id", comment: "专题id"
    t.integer "article_id", comment: "资讯id"
    t.integer "position", comment: "排序"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specials", force: :cascade, comment: "专题表" do |t|
    t.string "name", comment: "专题名"
    t.integer "template", comment: "模板"
    t.text "describe", comment: "简介"
    t.string "article_name", comment: "资讯名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 1, comment: "状态, 1:展示 2:隐藏"
    t.string "author", comment: "编辑人"
    t.integer "article_id", comment: "资讯id"
    t.datetime "published_at", comment: "发布时间"
  end

  create_table "statistic_records", force: :cascade do |t|
    t.integer "amount", default: 0, comment: "今日更新数量"
    t.integer "kind", comment: "类型"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "record_time", comment: "统计时间"
    t.string "owner_type"
    t.integer "owner_id"
  end

  create_table "support_categories", force: :cascade, comment: "帮助主题分类" do |t|
    t.string "name", comment: "名称"
    t.string "describe", comment: "描述"
    t.integer "position", comment: "排序"
    t.integer "state", comment: "状态 1:显示 2:隐藏"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supports", force: :cascade, comment: "帮助中心主题" do |t|
    t.string "title", comment: "标题"
    t.text "content", comment: "内容"
    t.integer "position", comment: "排序"
    t.integer "state", comment: "状态"
    t.integer "support_category_id", comment: "帮助中心分类id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_position", comment: "显示位置"
  end

  create_table "task_categories", force: :cascade, comment: "任务分类" do |t|
    t.string "name", comment: "分类名称"
    t.text "describe", comment: "分类描述"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_volunteers", force: :cascade, comment: "任务的志愿者表" do |t|
    t.integer "task_id", comment: "任务id"
    t.integer "volunteer_id", comment: "志愿者id"
    t.string "comment", comment: "管理员评论"
    t.text "achievement_comment", comment: "成果描述"
    t.integer "duration", comment: "时长"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "finish_time", comment: "任务完成时间"
    t.datetime "approve_time", comment: "审核时间"
    t.integer "user_id", comment: "审核人id"
    t.string "source", comment: "获得来源"
    t.integer "kind", comment: "类型"
    t.text "reason", comment: "申请理由"
    t.integer "state"
    t.index ["state"], name: "index_task_volunteers_on_state"
    t.index ["task_id"], name: "index_task_volunteers_on_task_id"
    t.index ["volunteer_id"], name: "index_task_volunteers_on_volunteer_id"
  end

  create_table "tasks", force: :cascade, comment: "任务表" do |t|
    t.string "name", comment: "任务名"
    t.integer "duration", comment: "时长"
    t.text "content", comment: "内容"
    t.integer "num", comment: "人数"
    t.integer "state", comment: "状态"
    t.integer "major_id", comment: "专业id"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time", comment: "任务开始时间"
    t.datetime "end_time", comment: "任务结束时间"
    t.integer "kind"
    t.integer "task_category_id", comment: "任务分类ID"
    t.integer "workplace_id", comment: "工作地点ID"
    t.datetime "apply_end_at", comment: "申请结束时间"
    t.string "task_no", comment: "任务编号"
    t.boolean "ordinary_flag", default: false, comment: "日常"
    t.boolean "intensive_flag", default: false, comment: "重点"
    t.boolean "urgency_flag", default: false, comment: "紧急"
    t.boolean "innovative_flag", default: false, comment: "创新"
    t.boolean "difficult_flag", default: false, comment: "难点"
    t.string "principal", comment: "任务负责人"
  end

  create_table "teacher_projects", force: :cascade, comment: "老师项目表" do |t|
    t.integer "teacher_id", comment: "老师id"
    t.integer "project_id", comment: "项目id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade, comment: "老师表" do |t|
    t.string "name", comment: "老师姓名"
    t.string "nickname", comment: "老师昵称"
    t.integer "user_id", comment: "用户ID"
    t.integer "school_id", comment: "学校ID"
    t.integer "kind", default: 2, comment: "老师类型：1:校长 2:老师"
    t.string "phone", comment: "老师电话号码"
    t.integer "state", default: 1, comment: "老师状态: 1:启用 2:禁用"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "id_card", comment: "身份证"
    t.string "qq", comment: "QQ"
    t.string "openid", comment: "微信openid"
    t.string "wechat", comment: "微信"
    t.jsonb "archive_data", comment: "归档旧数据"
  end

  create_table "teams", force: :cascade, comment: "小组" do |t|
    t.string "name", comment: "名称"
    t.integer "member_count", comment: "会员数"
    t.decimal "current_donate_amount", precision: 14, scale: 2, default: "0.0", comment: "当前捐助金额"
    t.decimal "total_donate_amount", precision: 14, scale: 2, default: "0.0", comment: "捐助总额"
    t.integer "creater_id", comment: "团队创建人id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "team_no", comment: "团队编号"
    t.integer "kind", comment: "分类：社会（society）高校（college）"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区县"
    t.string "address", comment: "详细地址"
    t.text "describe", comment: "简介"
    t.string "school_name", comment: "高校名称"
    t.integer "manage_id", comment: "负责人"
    t.integer "state"
  end

  create_table "users", force: :cascade, comment: "用户" do |t|
    t.string "openid", comment: "微信openid"
    t.string "name", comment: "姓名"
    t.string "login", comment: "登录账号"
    t.string "password_digest", comment: "密码"
    t.integer "state", default: 1, comment: "状态 1:启用 2:禁用"
    t.integer "team_id", comment: "团队ID"
    t.jsonb "profile", comment: "微信profile"
    t.integer "gender", comment: "性别，1：男 2：女"
    t.decimal "balance", precision: 14, scale: 2, default: "0.0", comment: "账户余额"
    t.string "phone", comment: "联系方式"
    t.string "email", comment: "电子邮箱地址"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname", comment: "昵称"
    t.string "salutation", comment: "孩子们如何称呼我"
    t.string "consignee", comment: "收货人"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.string "address", comment: "详细地址"
    t.string "qq", comment: "qq号"
    t.string "id_card", comment: "身份证"
    t.decimal "donate_amount", precision: 14, scale: 2, default: "0.0", comment: "捐助金额"
    t.decimal "online_amount", precision: 14, scale: 2, default: "0.0", comment: "线上捐助金额"
    t.decimal "offline_amount", precision: 14, scale: 2, default: "0.0", comment: "线下捐助金额"
    t.string "auth_token", comment: "Token"
    t.integer "manager_id", comment: "线下用户管理人id"
    t.integer "roles_mask", comment: "角色"
    t.integer "kind", default: 2, comment: "用户类型 1:平台用户 2:线上用户 3:线下用户"
    t.integer "phone_verify", default: 1, comment: "手机认证 1:未认证 2:已认证"
    t.decimal "promoter_amount_count", precision: 14, scale: 2, default: "0.0", comment: "累计劝捐额"
    t.integer "use_nickname", comment: "使用昵称"
    t.datetime "join_team_time", comment: "加入团队时间"
    t.integer "camp_id", comment: "探索营id"
    t.jsonb "project_ids", default: [], comment: "可管理项目（项目管理员）"
    t.boolean "notice_state", default: false, comment: "用户是否有未查看的公告"
    t.jsonb "archive_data", comment: "归档旧数据"
    t.index ["email"], name: "index_users_on_email"
    t.index ["login"], name: "index_users_on_login"
    t.index ["phone"], name: "index_users_on_phone"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.string "ip"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "visit_children", force: :cascade, comment: "家访记录学生表" do |t|
    t.integer "visit_id", comment: "家访ID"
    t.integer "child_id", comment: "孩子ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade, comment: "家访记录表" do |t|
    t.integer "owner_id"
    t.string "owner_type"
    t.text "content", comment: "内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "apply_child_id", comment: "孩子申请ID"
    t.integer "user_id", comment: "用户ID"
    t.string "investigador", comment: "调查人员"
    t.string "escort", comment: "陪同人员"
    t.datetime "survey_time", comment: "调查时间"
    t.integer "family_size", comment: "家庭人数"
    t.string "family_basic", comment: "家庭基本情况"
    t.text "basic_information", comment: "基本情况"
    t.text "income_information", comment: "收入情况"
    t.text "expenditure_information", comment: "支出情况"
    t.string "lodge", comment: "是否寄宿"
    t.decimal "lodge_cost", precision: 14, scale: 2, default: "0.0", comment: "住宿费用"
    t.text "other_subsidize", comment: "其他资助"
    t.text "prize_information", comment: "获奖情况"
    t.text "study_information", comment: "学习情况"
    t.decimal "tuition_fee", precision: 14, scale: 2, default: "0.0", comment: "学杂费"
    t.string "sponsor_fee", comment: "是否赞助生活费"
  end

  create_table "volunteer_major_ships", force: :cascade do |t|
    t.integer "volunteer_id", comment: "志愿者ID"
    t.integer "major_id", comment: "专业ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "volunteers", force: :cascade, comment: "志愿者表" do |t|
    t.integer "level", comment: "等级"
    t.integer "duration", comment: "服务时长"
    t.integer "user_id", comment: "用户"
    t.integer "job_state", comment: "任务状态"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", comment: "类型"
    t.integer "approve_state", comment: "认证状态"
    t.datetime "approve_time", comment: "认证时间"
    t.text "approve_remark", comment: "审核备注"
    t.string "volunteer_no", comment: "志愿者编号"
    t.string "volunteer_apply_no", comment: "志愿者申请编号"
    t.integer "internship_state", comment: "实习还是正式"
    t.text "describe", comment: "个人简介"
    t.string "phone", comment: "手机号"
    t.string "workstation", comment: "工作单位"
    t.jsonb "leave_reason", comment: "请假原因[类型, 说明]"
    t.boolean "task_state", default: false, comment: "志愿者是否有未查看的指派任务"
    t.string "name", comment: "志愿者真实姓名"
    t.string "id_card", comment: "志愿者身份证"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区县"
    t.string "address", comment: "详细地址"
    t.integer "gender", comment: "性别"
    t.string "source", comment: "获知渠道"
    t.text "experience", comment: "志愿者经历"
    t.integer "volunteer_age", comment: "服务年限"
    t.jsonb "archive_data", comment: "归档旧数据"
  end

  create_table "voucher_donate_records", force: :cascade, comment: "捐赠收据捐助记录表" do |t|
    t.integer "voucher_id", comment: "捐赠收据ID"
    t.integer "donate_record_id", comment: "捐赠记录ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vouchers", force: :cascade, comment: "捐助收据表" do |t|
    t.integer "user_id", comment: "用户ID"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.integer "state", comment: "状态"
    t.string "contact_name", comment: "联系人姓名"
    t.string "contact_phone", comment: "联系人电话"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.string "address", comment: "详细地址"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", comment: "开票类型"
    t.string "tax_no", comment: "开票税号"
    t.string "voucher_no", comment: "发票编号"
    t.string "tax_company", comment: "开票单位"
  end

  create_table "workplaces", force: :cascade, comment: "任务地点" do |t|
    t.string "title", comment: "名称"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区县"
    t.string "address", comment: "详细地址"
    t.text "describe", comment: "描述"
    t.integer "state", default: 1, comment: "显示状态：1:显示 2:隐藏"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
