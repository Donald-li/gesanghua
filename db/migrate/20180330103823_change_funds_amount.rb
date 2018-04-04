class ChangeFundsAmount < ActiveRecord::Migration[5.1]
  def change
    change_table :funds do |t|
      t.rename :amount, :balance # 财务分类余额

    end
  end
end
