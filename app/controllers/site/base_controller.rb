class Site::BaseController < ApplicationController
  before_action :check_mobile_url, :set_promoter_id

  rescue_from Exception, :with => :render_error

  private
  def check_mobile_url
    if request.env["HTTP_USER_AGENT"].to_s.downcase =~ /(mobile|android|iphone|micromessenger)/  #如果是移动端
      path = request.path
      query_string = request.query_string
      new_url = '/m/'

      case path
      when /\/pairs\/(\d+)\/detail/
        new_url = "/m/pair/#{$1}"
      when /\/camps\/(\d+)\/detail/
        new_url = "/m/camps/#{$1}"
      when /\/reads\/(\d+)\/detail/
        new_url = "/m/reads/apply/#{$1}"
      when /\/goods\/(\d+)\/detail/
        new_url = "/m/goods/#{$1}"
      when /\/campaigns\/(\d+)/
        new_url = "/m/campaign/#{$1}"
      else
        new_url = '/m/'
      end
      new_url << "?#{query_string}" if query_string.present?
      redirect_to new_url
    end
  end

  def render_error(exception = nil)
    unless Rails.env == 'development'
    case exception
      when ActiveRecord::RecordNotFound, ::ActionController::RoutingError
        render :file => "#{Rails.root}/public/404.html", :status => 404
      else
        render :file => "#{Rails.root}/public/500.html", :status => 500
    end
    else
      raise exception
    end
    logger.info exception.try(:inspect)
  end

  def set_promoter_id
    promoter_id = request.query_parameters[:m]
    session[:promoter_id] = promoter_id if promoter_id.present?
  end

end
