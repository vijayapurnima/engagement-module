class ProjectsController < ApplicationController


  # methods that require an admin role
  before_action :require_admin_role, only: [:show]


  # The Endpoint used to retrieve details of particular Project of Notification
  #
  # @rest_url /projects/:id
  # @rest_action GET
  # @rest_param id [Integer] The ID of the projects whose details need to be retrieved
  #
  # @return [JSON]
  # @rest_return Project [Object] Project Object with details
  # @rest_return error_message [String] A message returned when retrieval of an Project fails
  def show
    result = Projects::GetProject.call(id: params[:id], columns: params[:columns], authorization: request.headers['HTTP_AUTHORIZATION'])
    if result.success?
      @project = result.project
    else
      render_interactor_error result
    end
  end


  end
