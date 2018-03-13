class Api::V1::BookshelvesController < Api::V1::BaseController
  before_action :set_bookshelf, only: [:define_name, :update, :edit]

  def define_name
    @bookshelf.title = params[:define_name]
    @bookshelf.save
    api_success(data: true, message: '冠名成功！')
  end

  def edit
    api_success(data: {bookshelf: {id: @bookshelf.id, classname: @bookshelf.classname, studentNumber: @bookshelf.student_number}})
  end

  def create
    @bookshelf = ProjectSeasonApplyBookshelf.new
    @bookshelf.classname = params[:class][:classname]
    @bookshelf.student_number = params[:class][:student_number]
    if @bookshelf.save
      api_success(data: {bookshelf_id: @bookshelf.id})
    else
      api_error(data: @bookshelf.errors.full_messages)
    end
  end

  def update
    if @bookshelf.update(classname: params[:class][:classname], student_number: params[:class][:student_number])
      api_success(data: {result: true, bookshelf_id: @bookshelf.id, bookshelf: @bookshelf})
    else
      api_error(data: @bookshelf.errors.full_messages)
    end
  end

  private
  def set_bookshelf
    @bookshelf = ProjectSeasonApplyBookshelf.find(params[:id])
  end

end
