class Api::V1::ReadsController < Api::V1::BaseController
  before_action :set_project, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @project
    api_success(data: @project.detail_builder)
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyBookshelf.address_group)
  end

  def applies_list
    @book_applies = ProjectSeasonApply.where(project: Project.book_project).pass.show.sorted
    @book_applies = @book_applies.where(school_city: params[:city]) if params[:city].present?
    @book_applies = @book_applies.where(school_district: params[:district]) if params[:district].present?
    @book_applies = @book_applies.page(params[:page]).per(params[:per])
    api_success(data: {read_list: @book_applies.map{|item| item.summary_builder if item.present?}, pagination: json_pagination(@book_applies)})
  end

  private
  def set_project
    @project = Project.book_project
  end
end