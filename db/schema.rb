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

ActiveRecord::Schema.define(version: 20171212063829) do

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
    t.integer "kind", default: 2, comment: "管理员类型 1:超级管理员 2:普通管理员"
    t.integer "integer", default: 2, comment: "管理员类型 1:超级管理员 2:普通管理员"
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
