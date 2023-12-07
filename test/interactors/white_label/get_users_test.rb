require 'test_helper'

class WhiteLabel::GetUsersTest < ActiveSupport::TestCase

  test "get users from TSBE Monolith with valid response" do
    data = [{"id":3,"email":"purni1@tsbe.com.au","name":"------","auth_token":"SFMyNTY.g3QAAAACZAAEZGF0YWEnZAAGc2lnbmVkbgYArlaESmEB.T_uwm-2nzmBc4AJ32FES74_QMnBt2crGW7U-wCM_ChA","code":nil,"code_created_at":nil,"verified":true,"status":"active","user_type":"user","created_at":"2018-01-31T00:32:32.199Z","updated_at":"2018-01-31T04:40:42.418Z"},{"id":1,"email":"vijaya@tsbe.com.au","name":"Mrs.Vijaya","auth_token":"SFMyNTY.g3QAAAACZAAEZGF0YWEFZAAGc2lnbmVkbgYAJsMUrGEB.EK-bOlHMcKdrN4kS7CiR9Icw9qJMMRb2eQMOQ8ZxYBI","code":nil,"code_created_at":nil,"verified":true,"status":"active","user_type":"user","created_at":"2017-08-02T02:39:58.210Z","updated_at":"2018-02-19T03:21:37.340Z"},{"id":2,"email":"purni@tsbe.com.au","name":"purni","auth_token":nil,"code":"FRPZ6WG7","code_created_at":"2017-10-17T05:26:05.762Z","verified":nil,"status":nil,"user_type":"user","created_at":"2017-10-17T05:26:05.769Z","updated_at":"2017-10-17T05:26:05.769Z"}]
    stub_request(:get, SystemConfig.get('tsbe/host') + "/users").to_return(status: [200], body: data.to_json, headers: {})
    result=WhiteLabel::GetUsers.call()
    assert result.success?
    assert result.users.length,3
  end

  test "get users from TSBE Monolith with invalid response" do
    stub_request(:get, SystemConfig.get('tsbe/host') + "/users").to_return(status: [500,"Internal Server Error"])
    result=WhiteLabel::GetUsers.call()
    assert_not result.success?
    assert result.message,"Cannot get Users from White-label"
  end

end