class NotificationsController < ApplicationController

  # methods that require an authentication to create
  before_action :require_auth, only: [:create]

  # methods that require an current_user and requires admin role
  before_action :set_current_user,:require_admin_role, only: [:index, :show, :update, :destroy]

  # methods that set comm prior to provided methods execution
  before_action :get_notification, only: [:show, :update, :destroy]

  # The Endpoint used to retrieve all Notifications corresponding to User of EDO based on which property
  #
  # @rest_url /notifications
  # @rest_action GET
  # @rest_param which [String] The which status of notifications need to be retrieved
  # @rest_param notification_type [String] The type of notification need to be retrieved
  #
  # @return [JSON]
  # @rest_return Notifications [Array] Array of Notification Objects with details
  # @rest_return error_message [String] A message returned when retrieval of Notifications of corresponding EDO fails
  def index
    @notification_type=params[:notification_type]
    @notifications = Rails.cache.fetch("presentation/controllers/notifications/#{params[:which]}/#{params[:notification_type]}/#{@current_user.group.id}", expires_in: 12.hours) do
      case params[:which]
        when 'un_notified'
          Notification.un_notified.where(group_id: @current_user.group.id, notification_type: params[:notification_type])
        when 'notified'
          Notification.notified.where(group_id: @current_user.group.id, notification_type: params[:notification_type])
        when 'all'
          Notification.all.where(group_id: @current_user.group.id, notification_type: params[:notification_type])
      end
    end
  end

  # The Endpoint used to create Notification
  #
  # @rest_url /notifications/notification
  # @rest_action POST
  # @rest_param notification_params [Object] The Notification params used for creating Notification
  # @rest_param current_user [User] User who is accessing this call for creating Notification
  #
  # @return [JSON]
  # @rest_return Notification [Object] Notification Object with details
  # @rest_return error_message [String] A message returned when Creation of Notification fails
  def create
    result = EdoNotifications::CreateNotification.call(notification_params)

    if result.success?
      @notification = result.notification
      render 'notifications/show'
    else
      render_interactor_error result
    end
  end



  # The Endpoint used to update Notification
  #
  # @rest_url /notifications/notification/:id
  # @rest_action PUT
  # @rest_param notification_params [Object] The notification params used for updating notification
  # @rest_param current_user [User] User who is accessing this call for updating notification
  #
  # @return [JSON]
  # @rest_return Notification [Object] notification Object with details
  # @rest_return error_message [String] A message returned when updation of Notification fails
  def update
    unless @notification.nil?
      result = EdoNotifications::UpdateNotification.call(id: @notification['id'], params: notification_params,current_user: @current_user)

      if result.success?
        @notification = result.notification
        render 'notifications/show'
      else
        render_interactor_error result
      end
    end
  end

  # The Endpoint used to getting Notification
  #
  # @rest_url /notifications/notification/:id
  # @rest_action GET
  # @rest_param ID [Integer] The notification ID used for retrieval of Notification
  # @rest_param current_user [User] User who is accessing this call for retrieving notification
  # Calls get_comm method for retrieving the notification
  #
  # @return [JSON]
  # @rest_return Notification [Object] Notification Object with details
  # @rest_return error_message [String] A message returned when retrieval of notification fails
  def show
    @notification_type=params[:notification_type]
    unless @notification.nil?
      render 'notifications/show'
    end
  end


  # The Endpoint which will delete the Notification
  #
  # @rest_url /notifications/id
  # @rest_action DELETE
  # @rest_param id [Integer] The ID of the notification that need to be deleted
  # @rest_param current_user [User] User who is accessing this call for deleting notification
  #
  # @return [JSON]
  # @rest_return Response [Object] Returns the Response with status ok on successful deletion of notification
  # @rest_return error_message [String] A message only returned when deletion of notification failed
  def destroy
    unless @notification.nil?
      result = EdoNotifications::DeleteNotification.call(id: @notification['id'])

      if result.success?
        head :ok
      else
        render_interactor_error result
      end
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

  # Method which will get the notification prior to all calls which has id
  #
  # @rest_param id [Integer] The ID of the notification that need to be retrieved
  # @rest_param current_user [User] User who is accessing this call for notification operations
  #
  # @return [JSON]
  # @rest_return Notification [Object] Notification Object with details
  # @rest_return error_message [String] A message only returned when retrieving Notification failed
  def get_notification
    @notification = Rails.cache.fetch("presentation/controller/notifications/get_notification/#{params[:id]}", expires_in: 1.seconds) do
      Notification.find(params[:id])
    end
  end

  # Method which validates the incoming parameters with the list inside it
  # Params which are not part of below will be excluded from being passed
  #
  # @rest_url /notifications/notification_params
  # @rest_action GET
  #
  # @rest_return Params [Object] Object with require parameters
  def notification_params
    params.require(:notification).permit(:id, :notification_id, :notification_type, :group_id, :notified_at,:notified_by_id, :comm_id)
  end

end
