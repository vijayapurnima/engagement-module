class ApplicationMailer < ActionMailer::Base

  layout 'mailer'

  before_action :attach_images

  HOSTNAME = ActionMailer::Base.default_url_options[:host]

  def attach_images
    attachments.inline['header.png'] = File.read('app/assets/images/TSBE Logo Acronyn only reduced size.jpg')
  end
end