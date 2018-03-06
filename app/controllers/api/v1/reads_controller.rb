class Api::V1::ReadsController < Api::V1::BaseController
  before_action :set_pair, only: [:show]

  def show
    api_error(message: '无效项目') && return unless @pair
    api_success(data: @pair.detail_builder)
  end

  def get_address_list
    api_success(data: ProjectSeasonApplyBookshelf.address_group)
  end

  def bookshelves_list
    @bookshelves = ProjectSeasonApply.where(project: Project.book_project).pass.show.sorted
    @bookshelves = @bookshelves.where(school_city: params[:city]) if params[:city].present?
    @bookshelves = @bookshelves.where(school_district: params[:district]) if params[:district].present?
    @bookshelves = @bookshelves.page(params[:page]).per(params[:per])
    api_success(data: {read_list: @bookshelves.map{|item| item.summary_builder if item.present?}, pagination: json_pagination(@bookshelves)})
  end

  private
  def set_pair
    @pair = Project.book_project
  end
end
