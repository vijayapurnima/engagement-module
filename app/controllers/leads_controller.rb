class LeadsController < ApplicationController

  # methods that require an admin role
  before_action :require_admin_role

  # The Endpoint used to retrieve all Leads corresponding to an EDO
  #
  # @rest_url /leads
  # @rest_action GET
  # @rest_param current_user [User] User who is accessing this call for getting leads
  #
  # @return [JSON]
  # @rest_return Leads [Array] Array of Lead Objects with details
  # @rest_return error_message [String] A message returned when retrieval of Leads of corresponding EDO fails
  def index

    @leads = Rails.cache.fetch("presentation/controller/leads/index/#{current_user.group_id}", expires_in: 1.hours) do
        Lead.by_edo(current_user.group_id)
    end
  end

  # The Endpoint used to create Lead
  #
  # @rest_url /leads/lead
  # @rest_action POST
  # @rest_param lead_params [Object] The lead params used for creating Lead
  # @rest_param current_user [User] User who is accessing this call for creating lead
  #
  # @return [JSON]
  # @rest_return Lead [Object] Lead Object with details
  # @rest_return error_message [String] A message returned when Creation of Lead fails
  def create

    result = Leads::CreateLead.call(params: lead_params, current_user: current_user)

    if result.success?
      @lead = result.lead
    else
      render_interactor_error result
    end
  end

 private

  # Method which validates the incoming parameters with the list inside it
  # Params which are not part of below will be excluded from being passed
  #
  # @rest_url /leads/lead_params
  # @rest_action GET
  #
  # @rest_return Params [Object] Object with require parameters
  def lead_params
    params.require(:lead).permit(
        :name,
        :contact,
        :phone,
        :email,
        :comments)
  end

end
