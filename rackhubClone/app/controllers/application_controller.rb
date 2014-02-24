class ApplicationController < ActionController::Base
  before_filter :admin_filter

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  rescue_from ActionController::UnknownAction, :with => :error_404
  rescue_from ActionController::RoutingError, :with => :render_404
  rescue_from Exception, :with => :render_500

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end

    render :template => "errors/error_404", :status => 404, :layout => 'application', :content_type => 'text/html'
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end

    render :template => "errors/error_500", :status => 500, :layout => 'application'
  end

  private
  def admin_filter
    user_id = session[:user_id]
    @admin = User.find(user_id) unless user_id.nil?
  end
end
