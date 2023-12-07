class EdosController < ApplicationController

  # methods that require an admin role
  before_action :require_admin_role, only: [:show, :members]

  # The Endpoint used to retrieve all EDOs
  #
  # @rest_url /groups
  # @rest_action GET
  #
  # @return [JSON]
  # @rest_return Groups [Array] Array of Groups with details
  # @rest_return error_message [String] A message returned when retrieval of Groups fails

  def index
    @columns = params[:columns] || %w(id name expansion)
    case params[:which]
    when 'edo'
      groups = Rails.cache.fetch("presentation/controllers/group/index/#{params[:which]}", expires_in: 12.hours) do
        Group.where(group_type: 'edo')
      end
    when 'non_edo'
      groups = Rails.cache.fetch("presentation/controllers/group/index/#{params[:which]}", expires_in: 12.hours) do
        Group.where(group_type: 'non_edo')
      end
    else
      groups = Rails.cache.fetch("presentation/controllers/group/index/#{params[:which]}", expires_in: 12.hours) do
        Group.all
      end
    end

    @groups = groups.map do |group|
      group.slice(:id, :group_id, :group_type).merge({group: group.group_details(@columns)})
    end

    render json: @groups, status: :ok
  end

  # The Endpoint used to retrieve details of particular EDO
  #
  # @rest_url /edos/:id?with_organization=
  # @rest_action GET
  # @rest_param id [Integer] The ID of the EDO whose details need to be retrieved
  # @rest_param with_organization [Boolean] Boolean determines whether the edo members or levels need to be retrieved or not
  #
  # @return [JSON]
  # @rest_return Edo [Object] Edo Object with details
  # @rest_return error_message [String] A message returned when retrieval of an EDO fails
  def show
    result = Edos::GetEdo.call(id:params[:id],with_organization:params[:with_organization], columns: params[:columns])
    if result.success?
      render json:{edo: result.edo}, status: :ok
    else
      render_interactor_error result
    end
  end


  # The Endpoint used to update user's of particular EDO
  #
  # @rest_url /edos/:id/users
  # @rest_action PUT
  # @rest_param users [Array] Array of users with corresponding roles which need to be updated
  #
  # @return [JSON]
  # @rest_return Edo [Object] Edo Object with details
  # @rest_return error_message [String] A message returned when updation user's memberships of an EDO fails
  def update_users
    result = Edos::UpdateEdoMemberships.call(id:params[:id],users:params[:users],current_user:current_user)
    if result.success?
      @memberships = EdoMembership.by_edo(params[:id])
      render 'edos/users'
    else
      render_interactor_error result
    end
  end

  # The Endpoint used to members of particular EDO
  #
  # @rest_url /edos/:id/members?with_organization=
  # @rest_action GET
  # @rest_param id [Integer] The ID of the EDO whose members need to be retrieved
  # @rest_param with_organization [Boolean] Boolean determines whether the edo members or levels need to be retrieved or not
  #
  # @return [JSON]
  # @rest_return Edo [Object] Edo Object with details
  # @rest_return error_message [String] A message returned when retrieval of an EDO fails
  def members
    result = Edos::GetEdoMembers.call(id:params[:id],with_organization:params[:with_organization])
    if result.success?
      render json:{edo: result.edo}, status: :ok
    else
      render_interactor_error result
    end
  end

end
