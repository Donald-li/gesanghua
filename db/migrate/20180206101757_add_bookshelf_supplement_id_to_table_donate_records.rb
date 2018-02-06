class AddBookshelfSupplementIdToTableDonateRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :donate_records, :bookshelf_supplement_id, :integer, comment: '补书ID'
  end
end
