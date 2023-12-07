require 'test_helper'

class UsersController::VerifyTest < ActionController::TestCase
  test 'verify user with invalid code' do
    params = { verify: { code: 'FRPZ6WG1', password: 'purni123', group_id: groups(:one).id } }
    put :verify, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body, "User doesn't exist"
  end

  test 'verify user with valid code' do
    params = { verify: { code: 'FRPZ6WG3', password: 'purni123', group_id: groups(:one).id } }
    data = { "id": groups(:one).group_id, "name": 'TSBE', "expansion": 'Toowoomba & Surat Basin Enterprise',
             "group_levels": [], "organizations": [] }
    stub_request(:post, SystemConfig.get('auth/host') + '/auth_user').to_return(status: [201], headers: {})
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(
      status: [200], body: data.to_json, headers: {}
    )
    put :verify, format: 'text/json', params: params
    assert_response 200
    assert_equal User.find_by(email: 'kittu@tsbe.com').status, 'active'
  end

  test 'verify user with expired code' do
    params = { verify: { code: 'FRPZ6WG5', password: 'purni123', group_id: groups(:one).id } }
    put :verify, format: 'text/json', params: params
    assert_response 412
    assert_includes @response.body, 'Sorry, the verification link has expired. Please create another link'
  end

  test 'verify user with exception from auth service ' do
    params = { verify: { code: 'FRPZ6WG2', password: 'purni123', group_id: groups(:one).id } }
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/187?ECX_API=983ad8f7d05c021bfeab4be7173a7990&with_organization").to_return(status: 200,
                                                                                                    body: edo_data.to_json, headers: {})
    stub_request(:post, SystemConfig.get('auth/host') + '/auth_user').to_return(status: [500, 'Internal Server Error'])
    put :verify, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body, 'An error occured while processing your request. Please try again.'
  end

  test 'verify user without code' do
    params = { verify: { password: 'purni123', group_id: groups(:one).id } }
    put :verify, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body, 'Verification code is missing'
  end
end
