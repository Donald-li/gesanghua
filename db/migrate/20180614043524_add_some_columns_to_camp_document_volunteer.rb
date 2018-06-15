class AddSomeColumnsToCampDocumentVolunteer < ActiveRecord::Migration[5.1]
  def change
    add_column :camp_document_volunteers, :volunteer_no, :string, comment: "志愿者编号"
    add_column :camp_document_volunteers, :name, :string, comment: "姓名"
    add_column :camp_document_volunteers, :gender, :integer, comment: "性别"
    add_column :camp_document_volunteers, :id_card, :string, comment: "身份证号"
    add_column :camp_document_volunteers, :phone, :string, comment: "手机号"
    add_column :camp_document_volunteers, :content, :text, comment: "工作内容"
  end
end
