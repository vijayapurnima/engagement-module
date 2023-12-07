require 'base64'

class Forms::UpdateForm
  include ExtendedInteractor

  def call
    after_check do
      response = RestClient.put(
        SystemConfig.get('form/host') + "/forms/#{context[:form_id]}",
        {
          form: context[:form_details],
          service_name: context[:service]
        }
      )
      context[:form] = JSON.parse(response) if response.code == 200
    rescue RestClient::Exception => e
      puts e.message, e.response
      Sentry.capture_exception(e)
      context.fail!(message: 'form.create')
    end
  end

  def check_context
    context.fail!(message: 'form.missing_identifier') unless context[:form_id]
  end
end
