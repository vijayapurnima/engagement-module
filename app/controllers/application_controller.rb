class ApplicationController < ActionController::API
  include Secured

  include ActionController::ImplicitRender

  before_action :require_auth
  # https://stackoverflow.com/questions/711418/how-to-prevent-browser-page-caching-in-rails
  before_action :set_cache_headers
  rescue_from ::ActiveRecord::RecordInvalid, with: :invalid_data

  SERVICE_NAME = 'EDOC-'

  def render_interactor_error(result)
    result[:json] = {code: result[:message], description: I18n.t(result[:message])}
    result[:status] ||= :unprocessable_entity

    render json:result[:json], status:result[:status]
  end

  def render_generic_error(result)
    result[:json] = {code: result[:code], description: result[:message]}
    result[:status] ||= :unprocessable_entity

    render json: result[:json], status: result[:status]
  end

  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def invalid_data(exception)
    return render_generic_error(message: exception.message, status: :unprocessable_entity)
  end
end
