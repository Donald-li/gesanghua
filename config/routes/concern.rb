concern :switch do
  member { put :switch }
end
concern :move do
  member { put :move }
end
concern :list do
  collection { get :list }
end
concern :download do
  member { get :download }
end
concern :recommend do
  member { put :recommend }
end
concern :excel_output do
  collection { get :excel_output }
end
concern :excel_upload do
  collection { get :excel_upload}
end
concern :excel_import do
  collection { put :excel_import}
end
concern :share do
  member { get :share }
end
concern :file_download do
  member { get :file_download }
end

concern :qrcode_download do
  member { get :qrcode_download }
end

concern :remarks do
  member { get :remarks }
end

concern :cancel do
  member { get :cancel }
end

concern :info do
  collection { get :info }
end

concern :check do
  member { patch :check }
end

concern :detail do
  member { get :detail }
end