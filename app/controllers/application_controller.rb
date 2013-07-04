class ApplicationController < ActionController::Base
  protect_from_forgery

  def in_frame?
    params[:frame].present?
  end
  helper_method :in_frame?

end
