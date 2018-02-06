class AddAuditStateToTableBookshelfSupplements < ActiveRecord::Migration[5.1]
  def change
    add_column :bookshelf_supplements, :audit_state, :integer, comment: '审核状态'
    add_column :bookshelf_supplements, :show_state, :integer, comment: '显示状态'
  end
end
