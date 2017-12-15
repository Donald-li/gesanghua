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

ActiveRecord::Schema.define(version: 20171215074500) do

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
    t.string "login", comment: "登录名"
    t.string "nickname", comment: "昵称"
    t.string "password_digest", comment: "密码"
    t.datetime "expire_at", default: "2099-12-31 00:00:00", comment: "过期时间"
    t.integer "state", default: 1, comment: "状态 1:正常 2:禁用"
    t.integer "kind", default: 2, comment: "管理员类型 1:超级管理员 2:项目管理员"
    t.integer "integer", default: 2, comment: "管理员类型 1:超级管理员 2:项目管理员"
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

  create_table "bookshelves", force: :cascade, comment: "书架表" do |t|
    t.string "title", comment: "名称"
    t.integer "school_id", comment: "学校id"
    t.string "class_name", comment: "班级名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donate_records", force: :cascade, comment: "捐赠记录" do |t|
    t.integer "user_id", comment: "用户id"
    t.string "appoint_type", comment: "指定类型"
    t.integer "appoint_id", comment: "指定类型"
    t.integer "finance_category_id", comment: "类别id"
    t.integer "pay_state", comment: "状态"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "任务id"
    t.integer "project_id", comment: "项目id"
    t.integer "project_apply_id", comment: "项目申请id"
    t.integer "team_id", comment: "小组id"
    t.string "message", comment: "汇款信息"
    t.string "donor", comment: "捐赠者"
    t.integer "promoter_id", comment: "劝捐人"
    t.string "remitter_name", comment: "汇款人姓名"
    t.integer "remitter_id", comment: "汇款人id"
    t.integer "voucher_state", comment: "捐赠收据状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenditure_records", force: :cascade, comment: "支出记录表" do |t|
    t.integer "finance_category_id", comment: "类别id"
    t.integer "appoint_type", comment: "指定类型"
    t.integer "appoint_id", comment: "指定类型id"
    t.integer "administrator_id", comment: "管理员id"
    t.integer "income_record_id", comment: "入账记录类型id"
    t.integer "deliver_state", comment: "快递状态"
    t.integer "kind", comment: "类别"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

  create_table "income_records", force: :cascade, comment: "入帐记录表" do |t|
    t.integer "user_id", comment: "用户id"
    t.integer "finance_category_id", comment: "类别id"
    t.string "appoint_type", comment: "指定类型"
    t.integer "appoint_id", comment: "指定类型id"
    t.integer "state", comment: "状态"
    t.integer "income_source_id", comment: "来源id"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "任务id"
    t.decimal "balance", precision: 14, scale: 2, default: "0.0", comment: "余额"
    t.string "remitter_name", comment: "汇款人姓名"
    t.integer "remitter_id", comment: "汇款人id"
    t.string "donor", comment: "捐赠者"
    t.integer "promoter_id", comment: "劝捐人"
    t.integer "donate_record_id", comment: "捐助记录id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "income_sources", force: :cascade, comment: "收入来源" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "majors", force: :cascade, comment: "登记" do |t|
    t.string "name", comment: "标题"
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

  create_table "remarks", force: :cascade, comment: "备注信息" do |t|
    t.text "content", comment: "内容"
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "operator_type", comment: "操作类型"
    t.integer "operator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade, comment: "报告表" do |t|
    t.string "title", comment: "标题"
    t.text "content", comment: "内容"
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "type", comment: "单表：audit_report、financial_report、project_report"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "special_articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "specials", force: :cascade do |t|
    t.string "name", comment: "位置"
    t.integer "template", comment: "位置"
    t.integer "describe", comment: "位置"
    t.integer "article_name", comment: "位置"
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

  create_table "task_volunteers", force: :cascade, comment: "任务中间表" do |t|
    t.integer "task_id", comment: "任务id"
    t.integer "volunteer_id", comment: "志愿者id"
    t.string "comment", comment: "管理员评论"
    t.integer "achievement_comment", comment: "成果描述"
    t.integer "duration", comment: "时长"
    t.integer "approve_state", comment: "审核状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade, comment: "任务表" do |t|
    t.string "name", comment: "任务名"
    t.integer "duration", comment: "时长"
    t.integer "content", comment: "内容"
    t.integer "num", comment: "人数"
    t.integer "state", comment: "状态"
    t.integer "major_id", comment: "等级"
    t.integer "province", comment: "省"
    t.integer "city", comment: "市"
    t.integer "district", comment: "区"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade, comment: "小组" do |t|
    t.string "name", comment: "名称"
    t.integer "member_count", comment: "会员数"
    t.decimal "current_donate_amount", precision: 14, scale: 2, default: "0.0", comment: "当前捐助金额"
    t.decimal "total_donate_amount", precision: 14, scale: 2, default: "0.0", comment: "捐助总额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "volunteers", force: :cascade, comment: "志愿者表" do |t|
    t.integer "level", comment: "等级"
    t.integer "major_id", comment: "专业id"
    t.integer "duration", comment: "服务时长"
    t.integer "user_id", comment: "用户"
    t.integer "job_state", comment: "任务状态"
    t.integer "state", comment: "状态"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
