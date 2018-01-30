class CreateBeneficialChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :beneficial_children do |t|
      t.string :id_no, comment: '身份证号'
      t.string :name, comment: '姓名'
      t.integer :gender, comment: '性别'
      t.integer :nation, comment: '民族'
      t.integer :gsh_bookshelf_id, comment: '图书角ID'
      t.integer :project_season_apply_id, comment: '项目申请ID'

      t.timestamps
    end

    add_column :gsh_bookshelves, :bookshelf_no, :string, comment: '图书角编号'
    add_column :gsh_bookshelves, :univalence, :decimal, precision: 14, scale: 2, default: '0.0', comment: '单个金额'
    add_column :gsh_bookshelves, :balance, :decimal, precision: 14, scale: 2, default: '0.0', comment: '单个筹款剩余金额'
    add_column :gsh_bookshelves, :extra_amount, :decimal, precision: 14, scale: 2, default: '0.0', comment: '补书金额'
    add_column :gsh_bookshelves, :audit_state, :integer, comment: '审核状态'
    add_column :gsh_bookshelves, :show_state, :integer, comment: '展示状态'
    add_column :gsh_bookshelves, :state, :integer, comment: '执行状态'
    add_column :gsh_bookshelves, :project_season_apply_id, :integer, comment: '项目申请ID'
    add_column :gsh_bookshelves, :project_season_id, :integer, comment: '批次申请ID'

    add_column :project_seasons, :bookshelf_univalence, :decimal, precision: 14, scale: 2, default: '0.0', comment: '单个图书角金额'

    remove_column :project_season_applies, :gsh_child_id, :integer
    remove_column :project_season_applies, :gsh_bookshelf_id, :integer

    add_column :project_season_applies, :bookshelf_type, :integer, comment: '悦读项目申请类型'
    add_column :project_season_applies, :contact_name, :string, comment: '联系人姓名'
    add_column :project_season_applies, :contact_phone, :string, comment: '联系人电话'
    add_column :project_season_applies, :audit_state, :integer, comment: '审核状态'
    add_column :project_season_applies, :abstract, :string, comment: '简述'
    add_column :project_season_applies, :address, :string, comment: '详细地址'

  end
end
