# The Class used for getting Creating Lead for corresponding EDO and lead details
#
# @rest_return Lead [Object] Lead Object with details
# @rest_return error_message [String] A message returned when Lead creation failed
class Leads::CreateLead
  include ExtendedInteractor

  # Call method used for creating the Lead associated with the EDO and details provided
  # Creates a new record in Leads Table with params provided
  #
  # @rest_param params [Object] The parameters used for Lead creation
  #
  # @rest_return Lead [Object] Lead Object  with details
  # @rest_return error_message [String] A message returned when Lead creation fails
  def call
    after_check do
      lead=Lead.new(user:context[:current_user])
      params = context[:params].select {|p, v| Lead::CREATE_PARAMS.include? p}
      lead.assign_attributes(params)
      if lead.validate_lead_data
        lead.save!
        lead.reload
        UsersMailer.send_business_lead(lead, context[:current_user]).deliver_now!
      end

      context[:lead]=lead
    end
  end

  # Checks for lead user prior to lead creation
  #
  # @return [Object,nil] Returns an Error Object if check fails else nil
  def check_context
    unless context[:current_user]
      context.fail!(message: 'lead.missing_user')
    end
  end
end
