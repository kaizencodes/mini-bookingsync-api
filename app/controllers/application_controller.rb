class ApplicationController < ActionController::API
  before_filter :authenticate

  private

  def authenticate
    render :nothing, status: :unauthorized if params[:token] != "global_token"
  end
end
