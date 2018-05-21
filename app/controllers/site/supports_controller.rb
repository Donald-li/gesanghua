class Site::SupportsController < Site::BaseController

  def show
    @supports = Support.pc_support.show.sorted
    @support = Support.find(params[:id])
  end
end
