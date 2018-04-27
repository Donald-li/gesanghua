class Account::BaseController < ApplicationController
  before_action :login_require
  before_action :set_paper_trail_whodunnit

  layout 'account'

end
