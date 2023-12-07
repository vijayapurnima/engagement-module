require 'test_helper'

class UsersController::IndexTest < ActionController::TestCase

  test "get users of an EDO with unauthorised" do
    params={"which"=>"all"}
    get :index, format: 'text/json', params:params
    assert_response 401
  end


  test "get all users of an EDO with valid response" do
    params={"which"=>"all"}
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    get :index, format: 'text/json', params:params
    assert_response 200
    assert_includes @response.body,"purni@gmail.com"
    assert JSON.parse(@response.body).length,1
  end

  test "get active users of an EDO with valid response" do
    params={"which"=>"active"}
    @request.headers['SERVICE']="TSBE"

    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:three).id}.to_json,headers:{})
    get :index, format: 'text/json', params: params
    assert_response 200
    assert_not_includes @response.body,"sanju@tsbe.com"
    assert_includes @response.body,"sandeep@tsbe.com"
    assert JSON.parse(@response.body).length,1
  end
end