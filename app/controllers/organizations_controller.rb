class OrganizationsController < ApplicationController


  # methods that require an admin role
  before_action :require_admin_role, only: [:show]


  # The Endpoint used to retrieve details of particular EDO member
  #
  # @rest_url /organizations/:id
  # @rest_action GET
  # @rest_param id [Integer] The ID of the EDO member whose details need to be retrieved
  #
  # @return [JSON]
  # @rest_return Organization [Object] Organization Object with details
  # @rest_return error_message [String] A message returned when retrieval of an EDO member fails
  def show
    result = Organizations::GetOrganization.call(id: params[:id], authorization: request.headers['HTTP_AUTHORIZATION'], columns: params[:columns],access_level:'edo')
    if result.success?
      @organization = result.organization
    else
      render_interactor_error result
    end
  end

end
