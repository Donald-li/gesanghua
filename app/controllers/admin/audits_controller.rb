# 操作日志
class Admin::AuditsController < Admin::BaseController
  before_action :auth_superadmin
  def index
    set_search_end_of_day(:created_at_lteq)
    @search = PaperTrail::Version.order(id: :desc).where(item_type: ['Administrator', 'Company', 'Product', 'QrcodeAdvance', 'QrcodeApply', 'QrcodeBind']).
      where('whodunnit is not null').ransack(params[:q])
    scope = @search.result
    @audits = scope.page(params[:page])
  end

  def show
    @audit = PaperTrail::Version.find(params[:id])
  end
end
