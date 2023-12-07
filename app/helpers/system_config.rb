class SystemConfig

  DEV_VALUES = {
    'form/host': ENV['ECX_FORM_SERVICE_URL'] || 'http://localhost:3002',
    'auth/host': ENV['ECX_AUTH_SERVICE_URL'] || 'http://localhost:4000',
    'comm/host': ENV['ECX_COMM_SERVICE_URL'] || 'http://localhost:3008',
    'mr/host': ENV['ECX_MR_SERVICE_URL'] || 'http://localhost:4002',
    'file/host': ENV['ECX_FILE_SERVICE_URL'] || 'http://localhost:4001',
    'ecx/host': ENV['ECX_SERVICE_URL'] || 'http://localhost:3000',
    'tsbe/host': ENV['TSBE_SERVICE_URL'] || 'http://localhost:3005',
    'bus/host': ENV['ECX_BUS_SERVICE_URL'] || 'http://localhost:3004',
    'form/comm_form': ENV['COMMUNICATION_FORM'] || 1,
    'tsbe/group_id': ENV['TSBE_GROUP_ID'] || 1,
    'ecx/sales_team': ENV['ECX_SALES_TEAM_EMAIL'] || 'sales@economx.com',
    'form/notification_form': ENV['EDO_NOTIFICATION_FORM'] || 11,
    'ecx/api_key': ENV['EDO_ECX_API_KEY'] || '983ad8f7d05c021bfeab4be7173a7990'
  }

  def self.get key
    return nil if key.nil?
    if Rails.env.development? || Rails.env.test?
      DEV_VALUES[key.to_sym]
    else
      ssm_key = "/#{ENV['ENVIRONMENT']}/#{key}"
      Rails.cache.fetch("/config#{ssm_key}", expires_in: 1.hour) do
        get_raw(ssm_key)
      end
    end
  end

  def self.get_raw ssm_key
    ssm = Aws::SSM::Client.new
    response = ssm.get_parameter({name: ssm_key})
    response.parameter.value
  end

end