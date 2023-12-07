require 'test_helper'

class NotificationsController::DestroyTest < ActionController::TestCase

  test "delete notification with success response" do
    params = {"id" => 5}
    @request.headers['HTTP_AUTHORIZATION'] = "SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200], body: {user_id: users(:four).id}.to_json, headers: {})
    delete :destroy, format: 'text/json', params: params
    assert_response 200
    assert_not Notification.exists?(id:5)
  end

  test "delete notification with error response" do
    params = {"id" => 187}
    @request.headers['HTTP_AUTHORIZATION'] = "SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"

    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200], body: {user_id: users(:four).id}.to_json, headers: {})
    begin
      delete :destroy, format: 'text/json', params: params
    rescue ActiveRecord::RecordNotFound => exception
      assert_includes exception.message, "Couldn't find Notification with 'id'"
    end
  end
end