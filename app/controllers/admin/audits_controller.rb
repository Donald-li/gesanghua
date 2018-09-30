# 操作日志
class Admin::AuditsController < Admin::BaseController
  def index
    set_search_end_of_day(:created_at_lteq)
    @search = PaperTrail::Version.order(id: :desc).where(item_type: ['User', 'School', 'Teacher', 'Project', 'ProjectSeason', 'ProjectSeasonApply', 'ProjectSeasonApplyChild', 'GrantBatch', 'GshChildGrant', 'GshChild',
    'ProjectSeasonApplyBookshelf', 'BookshelfSupplement', 'Camp', 'CampDocumentEstimate', 'CampDocumentFinance', 'CampDocumentVolunteer', 'CampDocumentSummary', 'CampProjectResource', 'Volunteer', 'Campaign', 'CampaignEnlist', 'IncomeRecord', 'ExpenditureRecord']).
      where('whodunnit is not null').ransack(params[:q])
    scope = @search.result
    @audits = scope.page(params[:page])
  end

  def show
    @audit = PaperTrail::Version.find(params[:id])
  end
end
