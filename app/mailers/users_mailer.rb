# The Class used for sending mail alerts to Users
#
# @rest_return mail [Mail] Mail need to be delivered to users
# @rest_return error_message [String] A message returned when mail creation or delivery failed
class UsersMailer < ApplicationMailer


  # The method used for sending account verification mail for the user who registered to EDO
  # Calls send_mail method to deliver the mail with the content set
  #
  # @rest_return mail [Mail] Mail to be sent to user
  # @rest_return error_message [String] A message returned when verification mail creation or delivery failed
  def send_verification_email(user)
    @user = user
    @group = get_edo(user.group_id)
    @url = HOSTNAME + "#/user/verify"
    send_mail(@user.email, "Verification Email")
  end

  # The method used for sending password reset link  for the active user
  # Calls send_mail method to deliver the mail with the content set
  #
  # @rest_return mail [Mail] Mail to be sent to user
  # @rest_return error_message [String] A message returned when password reset mail creation or delivery failed
  def password_reset_link(user)
    @user = user
    @group = get_edo(user.group_id)
    @url = HOSTNAME + "#/user/changePassword"
    send_mail(@user.email, "Password Reset Link")
  end

  # The method used for sending notice regarding comm to selected recipients of Comm
  # Calls send_mail method to deliver the mail with the content set
  #
  # @rest_return mail [Mail] Mail to be sent to user
  # @rest_return error_message [String] A message returned when password reset mail creation or delivery failed
  def send_notice(user, comm_type, sender)
    @user = user
    @group = get_edo(sender.group_id)
    @sender = sender
    @comm_type = comm_type
    @url = HOSTNAME + "#/comm/index"
    send_mail(@user.email, "New #{comm_type} available from #{@sender.name}")
  end

  # The method used for sending business development lead to EconomX Sales Team
  # Calls send_mail method to deliver the mail with the content set
  #
  # @rest_return mail [Mail] Mail to be sent to email defined at SystemConfig.get('ecx/sales_team')
  # @rest_return error_message [String] A message returned when mail creation or delivery failed
  def send_business_lead(lead, sender)
    @lead = lead
    @sender = sender
    @group = get_edo(sender.group_id)
    send_mail(SystemConfig.get('ecx/sales_team'), 'New Business Development lead')
  end

  def send_alert_on_registration(user)
    @user = user
    @group = get_edo(user.group_id)
    @url = HOSTNAME + "#/user/resetPassword"
    send_mail(user.email, "Attempt to Re-register in #{@group[:expansion]}")
  end

  private

  # The method used for sending mail to the user with all parameters set
  # This method is called from all above methods to delivery the mails
  #
  # @rest_return mail [Mail] Mail to be sent to user
  # @rest_return error_message [String] A message returned when verification mail creation or delivery failed
  def send_mail(to, subject = nil, body = nil, template_path = nil, template_name = nil)
    mail(to: to, subject: subject, body: body, template_path: template_path, template_name: template_name) if to && to.to_s.length > 0
  end

  def get_edo(id)
    return nil if id.nil?

    result = Rails.cache.fetch("presentation/user_mailer/edo/#{id}", expires_in: 1.hours) do
      Edos::GetEdo.call(id: id)
    end

    if result.success?
      result.edo
    end
  end
end