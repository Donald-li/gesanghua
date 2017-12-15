class CreateIncomeSources < ActiveRecord::Migration[5.1]
  def change
    create_table :income_sources, comment: '收入来源' do |t|
      t.string :name, comment: '名称'    

      t.timestamps
    end
  end
end
