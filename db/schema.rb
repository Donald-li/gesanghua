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

ActiveRecord::Schema.define(version: 20180117035750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrator_logs", force: :cascade, comment: "管理员日志" do |t|
    t.integer "administrator_id", comment: "管理员id"
    t.integer "kind", comment: "日志动作类型，1:登录 2:登出"
    t.string "ip", comment: "ip地址"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administrators", force: :cascade, comment: "管理员" do |t|
    t.string "nickname", comment: "昵称"
    t.datetime "expire_at", default: "2099-12-31 00:00:00", comment: "过期时间"
    t.integer "state", default: 1, comment: "状态 1:正常 2:禁用"
    t.bigint "user_id"
    t.integer "kind", default: 2, comment: "管理员类型 1:超级管理员 2:系统管理员 3:项目管理员 4:财务人员"
    t.integer "integer", default: 2, comment: "管理员类型 1:超级管理员 2:系统管理员 3:项目管理员 4:财务人员"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_administrators_on_user_id"
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
  end

  create_table "campaigns", force: :cascade, comment: "活动表" do |t|
    t.string "name", comment: "名称"
    t.decimal "price", precision: 14, scale: 2, default: "0.0", comment: "报名费"
    t.text "content", comment: "内容"
    t.datetime "start_time", comment: "预计开始时间"
    t.datetime "end_time", comment: "预计结束时间"
    t.datetime "sign_up_end_time", comment: "报名截止时间"
    t.datetime "start_at", comment: "活动开始时间"
    t.datetime "end_at", comment: "活动结束时间"
    t.integer "state", default: 1, comment: "状态，1：展示 2：隐藏"
    t.integer "project_id", comment: "关联项目ID"
    t.integer "campaign_category_id", comment: "活动分类ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sign_up_start_time", comment: "报名开始时间"
    t.integer "number", comment: "报名限制人数"
    t.string "remark", comment: "报名表备注"
  end

  create_table "child_periods", force: :cascade, comment: "孩子捐助学期表" do |t|
    t.integer "grant_id", comment: "发放记录ID"
    t.integer "project_season_id", comment: "项目年度ID"
    t.integer "gsh_child_id", comment: "格桑花孩子ID"
    t.integer "donate_record_id", comment: "捐助记录ID"
    t.integer "user_id", comment: "捐赠人ID"
    t.string "name", comment: "名称"
    t.text "description", comment: "描述"
    t.integer "state", comment: "状态"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "资助金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "child_trails", force: :cascade, comment: "孩子轨迹表" do |t|
    t.integer "kind", comment: "分类，1：奖项 2：毕业 3：工作"
    t.text "content", comment: "详情"
    t.string "awarding_body", comment: "操作单位"
    t.datetime "awarding_at", comment: "操作时间"
    t.integer "child_id", comment: "孩子ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "donate_records", force: :cascade, comment: "捐赠记录" do |t|
    t.integer "user_id", comment: "用户id"
    t.string "appoint_type", comment: "指定类型"
    t.integer "appoint_id", comment: "指定类型"
    t.integer "fund_id", comment: "基金ID"
    t.integer "pay_state", comment: "付款状态"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "捐助金额"
    t.integer "project_id", comment: "项目id"
    t.integer "team_id", comment: "小组id"
    t.string "message", comment: "留言"
    t.string "donor", comment: "捐赠者"
    t.integer "promoter_id", comment: "劝捐人"
    t.string "remitter_name", comment: "汇款人姓名"
    t.integer "remitter_id", comment: "汇款人id"
    t.integer "voucher_state", comment: "捐赠收据状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_season_id", comment: "年度ID"
    t.integer "project_season_apply_id", comment: "年度项目ID"
    t.integer "project_season_apply_child_id", comment: "年度孩子申请ID"
    t.string "donate_no", comment: "捐赠编号"
    t.integer "voucher_id", comment: "捐助记录ID"
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
  end

  create_table "feedbacks", force: :cascade, comment: "反馈表" do |t|
    t.text "content", comment: "内容"
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "type", comment: "类型：receive、install、continual"
    t.integer "state", comment: "状态"
    t.integer "approve_state", comment: "审核状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", comment: "反馈类型"
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
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.decimal "total", precision: 14, scale: 2, default: "0.0", comment: "历史收入"
    t.integer "management_rate", default: 0, comment: "管理费率"
    t.string "describe", comment: "简介"
    t.integer "state", default: 1, comment: "状态 1:显示 2:隐藏"
    t.bigint "fund_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 1, comment: "类型 1:非定向 2:定向"
    t.integer "use_kind", default: 1, comment: "指定类型 1:非指定 2:指定"
    t.index ["fund_category_id"], name: "index_funds_on_fund_category_id"
  end

  create_table "goods_categories", force: :cascade, comment: "物资分类" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grants", force: :cascade, comment: "发放表" do |t|
    t.integer "project_id", comment: "归属项目ID"
    t.integer "project_season_id", comment: "项目年度ID"
    t.integer "school_id", comment: "学校ID"
    t.integer "project_season_apply_id", comment: "项目申请ID"
    t.integer "gsh_child_id", comment: "格桑花孩子ID"
    t.string "grant_no", comment: "发放编号"
    t.integer "state", comment: "状态"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "资助金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gsh_bookshelves", force: :cascade do |t|
    t.integer "school_id", comment: "关联学校id"
    t.string "classname", comment: "班级名"
    t.string "title", comment: "冠名"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
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
    t.string "cancel_reason", comment: "取消原因"
    t.integer "balance_manage", comment: "取消余额处理"
    t.text "cancel_remark", comment: "取消说明"
    t.string "title", comment: "标题"
    t.text "remark"
    t.index ["gsh_child_id"], name: "index_gsh_child_grants_on_gsh_child_id"
    t.index ["project_season_apply_id"], name: "index_gsh_child_grants_on_project_season_apply_id"
  end

  create_table "gsh_children", force: :cascade, comment: "格桑花孩子表" do |t|
    t.integer "school_id", comment: "关联学校id"
    t.string "name", comment: "孩子姓名"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.string "gsh_no", comment: "格桑花孩子编号"
    t.string "phone", comment: "联系电话"
    t.string "qq", comment: "qq号"
    t.integer "user_id", comment: "关联用户id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "idcard", comment: "身份证"
  end

  create_table "income_records", force: :cascade, comment: "入帐记录表" do |t|
    t.integer "user_id", comment: "用户id"
    t.integer "fund_id", comment: "基金ID"
    t.string "appoint_type", comment: "指定类型"
    t.integer "appoint_id", comment: "指定类型id"
    t.integer "state", comment: "状态"
    t.integer "income_source_id", comment: "来源id"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "入账金额"
    t.decimal "balance", precision: 14, scale: 2, default: "0.0", comment: "余额"
    t.string "remitter_name", comment: "汇款人姓名"
    t.integer "remitter_id", comment: "汇款人id"
    t.string "donor", comment: "捐赠者"
    t.integer "promoter_id", comment: "劝捐人"
    t.integer "donate_record_id", comment: "捐助记录id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "income_time", comment: "入账时间"
    t.text "remark", comment: "备注"
  end

  create_table "income_sources", force: :cascade, comment: "收入来源" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description", comment: "描述"
    t.integer "position", comment: "位置"
    t.integer "kind", comment: "类型： 1:线上（online） 2:线下（offline）"
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

  create_table "offline_donors", force: :cascade, comment: "代捐人表" do |t|
    t.integer "user_id", comment: "用户ID"
    t.string "name", comment: "姓名"
    t.integer "state", comment: "状态"
    t.integer "gender", comment: "性别，1：男 2：女"
    t.string "email", comment: "邮箱"
    t.string "phone", comment: "联系方式"
    t.string "address", comment: "详细地址"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "period_child_ships", force: :cascade, comment: "年度孩子和申请学期中间表" do |t|
    t.integer "project_season_apply_period_id", comment: "申请学期ID"
    t.integer "project_season_apply_child_id", comment: "年度孩子ID"
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
    t.integer "gsh_child_id", comment: "关联格桑花孩子id"
    t.integer "gsh_bookshelf_id", comment: "关联格桑花书架(图书角)id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", comment: "名称"
    t.integer "number", comment: "配额"
  end

  create_table "project_season_apply_bookshelves", force: :cascade, comment: "项目执行年度申请书架表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度id"
    t.integer "project_season_apply_id", comment: "关联项目执行年度申请id"
    t.integer "gsh_bookshelf_id", comment: "关联格桑花书架id"
    t.string "classname", comment: "班级名"
    t.string "title", comment: "冠名"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "筹款金额"
    t.decimal "surplus", precision: 14, scale: 2, default: "0.0", comment: "剩余捐款额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "grade", comment: "结对对应年级"
    t.integer "semester", comment: "结对对应学期"
  end

  create_table "project_season_apply_volunteers", force: :cascade, comment: "项目执行年度申请和志愿者关联表" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度id"
    t.integer "project_season_apply_id", comment: "关联项目执行年度的申请id"
    t.integer "volunteer_id", comment: "关联志愿者id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_season_courses", force: :cascade, comment: "项目执行年度的课程表(例：护花)" do |t|
    t.integer "project_id", comment: "关联项目id"
    t.integer "project_season_id", comment: "关联项目执行年度id"
    t.string "name", comment: "课程名称"
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
    t.string "owner_type"
    t.integer "owner_id"
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
    t.string "approve_remark", comment: "审核备注"
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
    t.integer "user_id", comment: "用户id"
    t.string "school_no", comment: "学校申请编号"
    t.string "contact_idcard", comment: "联系人身份证号"
    t.string "postcode", comment: "邮政编码"
    t.integer "teacher_count", comment: "教师人数"
    t.integer "logistic_count", comment: "后勤人数"
    t.string "contact_telephone", comment: "联系人座机号码"
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
  end

  create_table "statistic_records", force: :cascade do |t|
    t.integer "amount", default: 0, comment: "今日更新数量"
    t.integer "kind", comment: "类型"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "record_time", comment: "统计时间"
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
    t.string "alias", comment: "别名"
    t.text "content", comment: "内容"
    t.integer "position", comment: "排序"
    t.integer "state", comment: "状态"
    t.integer "support_category_id", comment: "帮助中心分类id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_volunteers", force: :cascade, comment: "任务的志愿者表" do |t|
    t.integer "task_id", comment: "任务id"
    t.integer "volunteer_id", comment: "志愿者id"
    t.string "comment", comment: "管理员评论"
    t.text "achievement_comment", comment: "成果描述"
    t.integer "duration", comment: "时长"
    t.integer "approve_state", comment: "审核状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "finish_time", comment: "任务完成时间"
    t.datetime "approve_time", comment: "审核时间"
    t.integer "user_id", comment: "审核人id"
    t.integer "finish_state", comment: "完成状态1:未完成doing 2:已完成done"
    t.string "source", comment: "获得来源"
    t.integer "kind", comment: "类型"
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
    t.string "idcard", comment: "身份证"
    t.string "qq", comment: "QQ"
    t.string "openid", comment: "微信openid"
  end

  create_table "teams", force: :cascade, comment: "小组" do |t|
    t.string "name", comment: "名称"
    t.integer "member_count", comment: "会员数"
    t.decimal "current_donate_amount", precision: 14, scale: 2, default: "0.0", comment: "当前捐助金额"
    t.decimal "total_donate_amount", precision: 14, scale: 2, default: "0.0", comment: "捐助总额"
    t.integer "creater_id", comment: "团队创建人id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "idcard", comment: "身份证"
    t.decimal "donate_count", precision: 14, scale: 2, default: "0.0", comment: "捐助金额"
    t.decimal "online_count", precision: 14, scale: 2, default: "0.0", comment: "线上捐助金额"
    t.decimal "offline_count", precision: 14, scale: 2, default: "0.0", comment: "线下捐助金额"
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
  end

  create_table "volunteers", force: :cascade, comment: "志愿者表" do |t|
    t.integer "level", comment: "等级"
    t.integer "major_id", comment: "专业id"
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

end
