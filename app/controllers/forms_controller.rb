class FormsController < ApplicationController

  # methods that require an admin role
  before_action :require_admin_role, :set_current_user

  # The Endpoint used to retrieve all forms corresponding to EDO
  #
  # @rest_url /forms
  # @rest_action GET
  # @rest_param current_user [User] The User  who is trying to get the Forms
  # @rest_param access_type [String] access_type to get extra details
  #
  # @return [JSON]
  # @rest_return Forms [Array] Array of Form Objects with details
  # @rest_return error_message [String] A message returned when retrieval of Forms of corresponding EDO fails
  def index
    result = Rails.cache.fetch("presentation/controller/forms/index/#{@current_user.id}", expires_in: 1.hours) do

      Forms::GetFormsByEdo.call(service_name: @current_user.service_name, access_type: 'owner')

    end
    if result.success?
      @forms = result.forms
    else
      render_interactor_error result
    end

  end


  # The Endpoint used to retrieve details of particular Form
  #
  # @rest_url /forms/id
  # @rest_action GET
  # @rest_param id [Integer] The ID of the Form whose data need to be retrieved
  #
  # @return [JSON]
  # @rest_return Form [Object] Form Object with details
  # @rest_return error_message [String] A message returned when retrieval of Form fails
  def show
    result = Rails.cache.fetch("presentation/controller/forms/show/#{params[:id]}", expires_in: 1.hours) do

      Forms::GetForm.call(id: params[:id],current_user:@current_user, access_type: 'owner')

    end
    if result.success?
      @form = result.form
    else
      render_interactor_error result
    end
  end


  # The Endpoint used to getting form for the Notification
  #
  # @rest_url /forms/notification_form
  # @rest_action GET
  # @rest_param current_user [User] User who is accessing this call for retrieving notification
  # Calls get_form method for retrieving the notification form
  #
  # @return [JSON]
  # @rest_return Notification [Object] Notification Object with details
  # @rest_return error_message [String] A message returned when retrieval of notification fails
  def notification_form
    form_id = SystemConfig.get('form/notification_form')
    service_name = ApplicationController::SERVICE_NAME[0, 4]
    result = Rails.cache.fetch("presentation/controller/forms/notification_form/#{form_id}", expires_in: 1.hours) do

      Forms::GetForm.call(id: form_id, service_name:service_name, current_user:@current_user, access_type: 'owner')

    end
    if result.success?
      @form = result.form
      render 'forms/show'
    else
      render_interactor_error result
    end
  end

  private

  # Method which will set the current_user prior to all calls which need authentication
  #
  # @return [JSON]
  # @rest_return User [Object] User Object with details
  # @rest_return error_message [String] A message only returned when retrieving Current User failed
  def set_current_user
    @current_user=current_user
  end

end
