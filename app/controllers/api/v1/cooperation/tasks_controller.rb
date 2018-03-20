class Api::V1::Cooperation::TasksController < Api::V1::BaseController

  def index
    tasks = Task.open.where.not(id: current_user.volunteer.task_volunteers.pluck(:task_id)).sorted
    tasks = tasks.page(params[:page]).per(params[:per])
    api_success(data: {tasks: tasks.map{|task| task.summary_builder}, pagination: json_pagination(tasks)})
  end

  def my_tasks
    volunteer = current_user.volunteer
    if params[:state] == 'allTask'
      tasks = Task.where(id: volunteer.task_volunteers.pluck(:task_id))
      tasks = tasks.where(state: [:open, :pick_done, :doing, :done, :cancel])
    elsif params[:state] == 'applyTask'
      tasks = Task.where(id: volunteer.task_volunteers.where(approve_state: [:submit, :reject]).pluck(:task_id))
      tasks = tasks.where(state: [:open, :pick_done])
    elsif params[:state] == 'toDoTask'
      tasks = Task.where(id: volunteer.task_volunteers.pass.pluck(:task_id))
      tasks = tasks.where(state: [:pick_done])
    elsif params[:state] == 'doingTask'
      tasks = Task.where(id: volunteer.task_volunteers.pass.pluck(:task_id))
      tasks = tasks.where(state: [:doing])
    elsif params[:state] == 'doneTask'
      tasks = Task.where(id: volunteer.task_volunteers.pass.pluck(:task_id))
      tasks = tasks.where(state: [:done])
    elsif params[:state] == 'cancelTask'
      tasks = Task.where(id: volunteer.task_volunteers.pluck(:task_id))
      tasks = tasks.where(state: [:cancel])
    end
    tasks = tasks.sorted.page(params[:page]).per(params[:per])
    api_success(data: {tasks: tasks.map{|task| task.summary_builder(current_user)}, pagination: json_pagination(tasks)})
  end

  def show
    task = Task.find(params[:id])
    api_success(data: task.detail_builder(current_user))
  end

  def apply
    task = Task.find(params[:id])
    volunteer = current_user.volunteer
    tv = TaskVolunteer.find_by(task: task, volunteer: volunteer)
    if !tv.present? || tv.reject?
      tv ||= volunteer.task_volunteers.new(reason: params[:reason], task: task)
      if tv.save
        api_success(data: true)
      else
        api_error(message: '申请失败，请重试')
      end
    else
      api_error(message: '您已经提交申请，请耐心等待审核')
    end
  end

  def cancel
    task = Task.find(params[:id])
    volunteer = current_user.volunteer
    tv = TaskVolunteer.find_by(task: task, volunteer: volunteer)
    if tv.cancel!
      api_success(message: '取消成功')
    else
      api_error(message: '取消失败')
    end
  end

  def finish

  end

end
