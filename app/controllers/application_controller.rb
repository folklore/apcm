class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :signed_in?, :current_user

  before_filter :signin_required

  private

    def signed_in?
      session[:current_user_id].present?
    end

    def signin_required
      redirect_to :root unless signed_in?
    end

    def current_user
      @current_user ||= User.where(id: session[:current_user_id]).first
    end

    def admin_required
      redirect_to :root unless signed_in? and current_user.is_admin?
    end

    def error_404
      render '404' and return
    end

end