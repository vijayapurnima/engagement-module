require 'test_helper'

class LoginsControllerTest < ActionController::TestCase

  #Login method test cases

  test "Create login with invalid login credentials" do
    params = {username: "purni@gmail.com", password: 'purni123'}
    stub_request(:post, SystemConfig.get('auth/host') + '/auth_session').to_return(status: [500, "Internal Server Error"])
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    put :login, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body, 'Incorrect username or password'
  end

  test "Create login with valid login credentials" do
    params = {username: "purni@gmail.com", password: 'purni123', group_id: groups(:one).id}
    user = users(:four)
    data={"data":{"token":"SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE","id":1157,"expire_time":"2018-02-12T02:36:42.461484Z"}}
    Users::LoginUser.stubs(:call).returns(OpenStruct.new({ success?: true, data: data, user_ref: user.try(:to_gid) }))
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/187?ECX_API=983ad8f7d05c021bfeab4be7173a7990&with_organization").
    to_return(status: 200, body: "", headers: {})

    put :login, format: 'text/json', params: params
    assert_response 200
    assert_includes @response.body, 'purni@gmail.com'
  end

  test "Create login without username" do
    params = { password: 'purni123'}
    put :login, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body, 'Username or password is not provided'
  end


  #Logout method test cases

  test "logout without auth_token in headers" do
    delete :logout, format: 'text/json',params:{id:4}
    assert_response 401
  end

  test "logout with auth_token in headers but error from auth_service" do
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"

    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    stub_request(:delete, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [500, "Internal Server Error"])
    delete :logout, format: 'text/json',params:{id:users(:four).id}
    assert_response 422
    assert_includes @response.body, 'User not logged in'
  end

  test "logout with valid auth_token" do
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    stub_request(:delete, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200])

    delete :logout, format: 'text/json', params: {id:users(:four).id}
    assert_response 200
  end

end

