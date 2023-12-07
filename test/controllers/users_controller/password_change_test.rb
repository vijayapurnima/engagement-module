require 'test_helper'

class UsersController::PasswordChangeTest < ActionController::TestCase

  test "change password with valid data" do
    params = {verify:{code: "FRPZ6WG2", password: 'purni123'}}
    stub_request(:put, SystemConfig.get('auth/host') + '/auth_user').to_return(status: [201], headers: {})
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    put :change_password, format: 'text/json', params: params
    user = users(:four)
    assert_response 200
    assert_nil user.code
  end

  test "change password with expired code" do
    params ={verify: {code: "FRPZ6WGC", password: 'purni123'}}
    put :change_password, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body,"Sorry, the verification link has expired. Please create another link"
  end

  test "change password with unverified user" do
    params = {verify:{code: "FRPZ6WG7", password: 'purni123'}}
    put :change_password, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body,"User doesn't exist"
  end

  test "change password without code" do
    params = {verify:{password: 'purni123'}}
    put :change_password, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body,"Verification code doesn't match"
  end

  test "change password without password" do
    params = {verify:{code: "FRPZ6WG7"}}
    put :change_password, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body,"Password is required"
  end

  test "change password error from auth service" do
    params = {verify:{code: "FRPZ6WG2", password: 'purni123'}}
    data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:put, SystemConfig.get('auth/host') + '/auth_user').to_return(status: [500, "Internal Server Error"])
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: data.to_json, headers: {})
    put :change_password, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body,"Incorrect username or password"
  end
end