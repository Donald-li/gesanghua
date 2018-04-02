class Account::BaseController < ApplicationController
  before_action :logged_in?
  before_action :set_paper_trail_whodunnit

  layout 'account'

end
