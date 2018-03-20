require 'rails_helper'

RSpec.describe "Api::V1::Cooperation::Tasks", type: :request do

  let!(:login_user) { create(:user) }
  let!(:volunteer) { create(:volunteer, user: login_user)}
  let!(:user) { create(:user) }
  let!(:task_category) { create(:task_category) }
  let!(:workplace) { create(:workplace) }
  let!(:task1) {create(:task, workplace: workplace, task_category: task_category, principal: user)}
  let!(:task2) {create(:task, workplace: workplace, task_category: task_category, principal: user)}

  describe '志愿者任务' do
    it '获取可申请任务' do
      login_user.volunteer.pass!
      get api_v1_cooperation_tasks_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取任务地区' do
      get workplace_api_v1_cooperation_tasks_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取任务分类' do
      get category_api_v1_cooperation_tasks_path, headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取任务详情' do
      get api_v1_cooperation_task_path(id: task1), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '申请任务' do
      post apply_api_v1_cooperation_tasks_path(id: task1), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '取消申请任务' do
      post apply_api_v1_cooperation_tasks_path(id: task1), headers: api_v1_headers(login_user)
      api_v1_expect_success

      get cancel_api_v1_cooperation_tasks_path(id: task1), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

    it '获取我的任务' do
      get my_tasks_api_v1_cooperation_tasks_path(state: 'allTask'), headers: api_v1_headers(login_user)
      api_v1_expect_success
    end

  end

end
