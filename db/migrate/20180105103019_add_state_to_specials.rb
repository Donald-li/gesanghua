class AddStateToSpecials < ActiveRecord::Migration[5.1]
  def change
    add_column :specials, :state, :integer,default: 1, comment: '状态, 1:展示 2:隐藏'
  end
end
