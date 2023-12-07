require 'rest-client'
# The Class used for getting  details of corresponding EDO
#
# @rest_return EDO [Object] EDO Object with details
# @rest_return error_message [String] A message returned when group retrieval fails
class Edos::GetEdo
  include ExtendedInteractor

  # Call method used for retrieving the group associated with the id provided
  # Calls Business Service to retrieve EDO details
  #
  # @rest_param id [Integer] The id of the EDO
  #
  # @rest_return EDO [Object] EDO Object with details with/without members based on with_organization flag
  # @rest_return error_message [String] A message returned when EDO retrieval fails
  def call
    after_check do

      group = Group.cached_find(context[:id])

      result = Rails.cache.fetch("presentation/interactor/get_edo/group_table_id=#{context[:id]}") do
        Groups::GetGroup.call(group_id: group.group_id, with_organization: context[:with_organization], columns: context[:columns])
      end

      if result.success?
        context[:edo] = result.group
        context[:edo][:group_type] = group.group_type
      end
    end
  end


  # Checks for id prior to edo/group retrieval
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
   unless context[:id]
      context.fail!(message: 'edo.missing_identifier')
    end
  end
end
