class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  include StaticRoutes
  before_filter :login_required
  helper_method :logged_in?, :current_user

  private

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def login_required
    redirect_to login_path unless logged_in?
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user ||= begin
      if session[:user_id] && (user = User.find_by(id: session[:user_id]))
        UserDecorator.decorate(user)
      end
    end
  end

end
