class Api::V1::BookshelvesController < Api::V1::BaseController
  before_action :set_bookshelf, only: [:define_name, :update, :edit]

  def define_name
    @bookshelf.title = params[:define_name]
    @bookshelf.save
    api_success(data: true, message: '冠名成功！')
  end

  def create
    @bookshelf = ProjectSeasonApplyBookshelf.new(
      classname: params[:class][:classname],
      student_number: params[:class][:student_number],
      school: current_user.school,
      province: current_user.school.try(:province),
      city: current_user.school.try(:city),
      district: current_user.school.try(:district),
      project: Project.read_project
    )
    if @bookshelf.save
      api_success(data: {result: true, bookshelf_id: @bookshelf.id}, message: '提交成功！')
    else
      api_success(data: {result: false}, message: '提交失败，请重试！')
    end
  end

  def edit
    api_success(data: {bookshelf: @bookshelf.apply_builder} )
  end

  def update
    if @bookshelf.update(
      classname: params[:class][:classname],
      student_number: params[:class][:student_number]
    )
      api_success(data: {result: true, bookshelf_id: @bookshelf.id}, message: '提交成功！')
    else
      api_success(data: {result: false}, message: '提交失败，请重试！')
    end
  end

  def class_list
    @apply = ProjectSeasonApply.find(params[:id])
    @bookshelves = @apply.bookshelves.pass.sorted
    api_success(data: @bookshelves.map { |b| b.class_list_summary_builder })
  end

  def show_logistic
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
    @logistic = @bookshelf.logistic
    api_success(data: @logistic.qurey_result)
  end

  private
  def set_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
  end

end
