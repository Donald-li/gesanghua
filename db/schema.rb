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

ActiveRecord::Schema.define(version: 20171215073621) do

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

  create_table "children", force: :cascade, comment: "格桑花孩子表" do |t|
    t.string "idcard", comment: "身份证"
    t.string "name", comment: "姓名"
    t.integer "school_id", comment: "学校ID"
    t.integer "user_id", comment: "用户ID"
    t.string "password_digest", comment: "密码"
    t.string "gsh_no", comment: "格桑花内部编码"
    t.integer "state", default: 1, comment: "状态：1:启用 2:禁用"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goods_categories", force: :cascade, comment: "物资分类" do |t|
    t.string "name", comment: "名称"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goods_project_apply_items", force: :cascade, comment: "物资类项目申请条目表" do |t|
    t.string "name", comment: "物品名称"
    t.integer "number", comment: "物品数量"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logistics", force: :cascade, comment: "物流表" do |t|
    t.string "name", comment: "物流公司"
    t.string "number", comment: "物流单号"
    t.string "owner_type"
    t.integer "owner_id"
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

  create_table "project_applies", force: :cascade, comment: "项目申请表" do |t|
    t.integer "user_id", comment: "用户ID"
    t.integer "project_id", comment: "项目ID"
    t.integer "state", default: 1, comment: "状态：1:启用 2:禁用"
    t.integer "approve_state", default: 1, comment: "申请状态：1:审核中 2:审核通过 3:审核不通过"
    t.integer "school_id", comment: "学校ID"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_apply_children", force: :cascade, comment: "一对一孩子申请表" do |t|
    t.integer "project_apply_id", comment: "项目申请ID"
    t.integer "child_id", comment: "格桑花孩子ID"
    t.integer "approve_state", comment: "审核状态：1:审核中 2:申请通过 3:申请不通过"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_quota", force: :cascade, comment: "项目配额" do |t|
    t.integer "school_id", comment: "学校ID"
    t.integer "project_id", comment: "项目ID"
    t.decimal "amount", precision: 14, scale: 2, default: "0.0", comment: "金额"
    t.string "province", comment: "省"
    t.string "city", comment: "市"
    t.string "district", comment: "区/县"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_templates", force: :cascade, comment: "项目模板表" do |t|
    t.string "name", comment: "项目模板名称"
    t.integer "kind", comment: "模板类型"
    t.integer "finance_category_id", comment: "财务分类ID"
    t.string "protocol_name", comment: "协议名称"
    t.text "protocol_content", comment: "协议内容"
    t.integer "contribute_kind", default: 1, comment: "捐款类型：1:整捐 2:零捐"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade, comment: "项目表" do |t|
    t.string "name", comment: "项目名称"
    t.integer "type", comment: "项目类型：1:结对 2:物资 3:悦读 4:营 5:观影"
    t.text "content", comment: "项目内容"
    t.integer "state", default: 1, comment: "项目状态：1:启用 2:禁用"
    t.integer "finance_category_id", comment: "财务分类ID"
    t.integer "contribute_kind", default: 1, comment: "捐款类型：1:整捐 2:零捐"
    t.integer "category_type", comment: "具体项目分类"
    t.integer "category_id", comment: "分类ID"
    t.integer "project_template_id", comment: "项目模板ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "read_project_apply_items", force: :cascade, comment: "悦读类项目申请条目表" do |t|
    t.string "name", comment: "名称"
    t.integer "number", comment: "数量"
    t.decimal "balance", precision: 14, scale: 2, default: "0.0", comment: "余额"
    t.string "title", comment: "冠名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "describe", comment: "学校简介"
    t.integer "state", default: 1, comment: "学校状态：1:启用 2:禁用"
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

end
