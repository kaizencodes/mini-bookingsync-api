class ApplicationController < ActionController::API
  before_action :authenticate

  private

  def authenticate
    render :nothing, status: :unauthorized if params[:token] != "global_token"
  end
end
