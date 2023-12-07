require 'test_helper'

class UsersController::CreateTest < ActionController::TestCase

  test "Create User with invalid domain" do
    params = {user: {email: "purvi@gmail.com", name: 'purni123', group_id: groups(:one).id}}
    data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: data.to_json, headers: {})
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns%5B%5D=name&with_organization").to_return(status: [200], body: data.to_json, headers: {})

    begin
      post :create, format: 'text/json', params: params
    rescue ActiveRecord::RecordInvalid => exception
      assert_equal exception.message, "Validation failed: Email requires valid domain"
    end
  end

  test "Create User with valid credentials" do
    params = {user: {email: "purvini@tsbe.com.au", name: 'purni123', group_id: groups(:one).id}}
    data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: data.to_json, headers: {})
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns%5B%5D=name&with_organization").to_return(status: [200], body: data.to_json, headers: {})
    post :create, format: 'text/json', params: params
    assert_response 200
    assert User.exists?(email: "purvini@tsbe.com.au")
    assert EdoMembership.exists?(user: User.find_by(email: "purvini@tsbe.com.au"))

  end

  test "does not fail when user exists" do
    params = {user: {email: "sanju@tsbe.com", name: 'purni123', group_id: groups(:one).id}}
    data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: data.to_json, headers: {})
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns%5B%5D=name&with_organization").to_return(status: [200], body: data.to_json, headers: {})
    post :create, format: 'text/json', params: params
    assert_response 200
  end
end