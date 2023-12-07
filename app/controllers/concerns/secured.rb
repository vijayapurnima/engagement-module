require 'rest-client'

module Secured
  extend ActiveSupport::Concern

  def authorized
    return nil if request.headers['HTTP_AUTHORIZATION'].nil? && request.headers['HTTP_AUTHENTICATION'].nil?
    response = RestClient.get(
        SystemConfig.get('auth/host') + "/auth_session?token=#{request.headers['HTTP_AUTHORIZATION'] || request.headers['HTTP_AUTHENTICATION']}&service_name=#{@service_name}"
    )
    response.code == 200
  rescue => error
    return nil
  end

  def current_user
    set_service_name
    return head :unauthorized unless authorized
    response = RestClient.get(
        SystemConfig.get('auth/host') + "/auth_session?token=#{request.headers['HTTP_AUTHORIZATION'] || request.headers['HTTP_AUTHENTICATION']}&service_name=#{@service_name}"
    )
    User.find(JSON.parse(response)['user_id'])
  rescue => error
    head :unauthorized
  end

  def validate_api_key
    key = request.headers['HTTP_EDO_API'] || request.params['EDO_API']
    puts "dxczxczxczx",key
    return nil if key.nil?
    response = RestClient.get(
        SystemConfig.get('auth/host') + "/app_key?key=#{key}&service_name=#{@service_name}"
    )
    response.code == 200
  rescue => error
    return nil
  end

  def require_auth
    set_service_name
    head :unauthorized unless authorized || validate_api_key
  end

  def require_admin
    set_service_name
    head :unauthorized unless current_user&.admin?
  end

  def deny_access
    head :forbidden
  end

  def require_admin_role
    set_service_name
    if authorized && current_user
      deny_access unless current_user.role_admin?
    else
      head :unauthorized
    end
  end

  def set_service_name
    service = request.headers['SERVICE']
    if service.nil?
      @service_name = ApplicationController::SERVICE_NAME[0, 4]
    else
      @service_name = ApplicationController::SERVICE_NAME + service
    end
  end
end