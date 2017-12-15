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

ActiveRecord::Schema.define(version: 20171215074559) do

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

  create_table "campaign_categories", force: :cascade, comment: "活动分类表" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaign_enlists", force: :cascade, comment: "活动用户表" do |t|
    t.integer "campaign_id", comment: "活动ID"
    t.integer "user_id", comment: "用户ID"
    t.integer "number", comment: "报名人数"
    t.string "remark", comment: "备注"
    t.decimal "total", precision: 14, scale: 2, default: "0.0", comment: "合计报名金额"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "state", comment: "状态，1：展示 2：隐藏"
    t.integer "project_id", comment: "关联项目ID"
    t.integer "campaign_category_id", comment: "活动分类ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "child_grants", force: :cascade, comment: "孩子发放记录表" do |t|
    t.integer "child_id", comment: "孩子ID"
    t.integer "project_apply_id", comment: "项目申请ID"
    t.integer "state", comment: "状态"
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

  create_table "education_bureau_employees", force: :cascade, comment: "教育局工作人员表" do |t|
    t.string "name", comment: "姓名"
    t.string "phone", comment: "联系方式"
    t.string "nickname", comment: "昵称"
    t.integer "kind", default: 1, comment: "类型，1：员工 2：局长"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "education_bureaus", force: :cascade, comment: "教育局表" do |t|
    t.string "name", comment: "名称"
    t.string "address", comment: "详细地址"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finance_categories", force: :cascade, comment: "财务分类表" do |t|
    t.string "name", comment: "名称"
    t.integer "position", comment: "排序"
    t.string "fund_name", comment: "基金名称"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.string "describe", comment: "简介"
    t.string "ancestry"
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

  create_table "users", force: :cascade, comment: "用户" do |t|
    t.string "openid", comment: "微信openid"
    t.string "name", comment: "姓名"
    t.string "login", comment: "登录账号"
    t.string "password_digest", comment: "密码"
    t.integer "state", default: 1, comment: "状态，0：禁用 1：启用"
    t.integer "team_id", comment: "团队ID"
    t.jsonb "profile", comment: "微信profile"
    t.integer "gender", comment: "性别，1：男 2：女"
    t.decimal "balance", precision: 14, scale: 2, default: "0.0", comment: "账户余额"
    t.string "phone", comment: "联系方式"
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

  create_table "visit_children", force: :cascade, comment: "家访记录学生表" do |t|
    t.integer "visit_id", comment: "家访记录ID"
    t.integer "project_apply_children_id", comment: "家访孩子ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visits", force: :cascade, comment: "家访记录表" do |t|
    t.integer "owner_id"
    t.string "owner_type"
    t.text "content", comment: "内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voucher_donate_records", force: :cascade, comment: "捐赠收据记录表" do |t|
    t.integer "voucher_id", comment: "捐赠收据ID"
    t.integer "donate_record_id", comment: "捐赠记录ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "voucher_income_records", force: :cascade, comment: "捐助收据入账记录表" do |t|
    t.integer "voucher_id", comment: "收据ID"
    t.integer "income_record_id", comment: "入账记录ID"
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
  end

end
