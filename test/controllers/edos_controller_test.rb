require 'test_helper'

class EdosControllerTest < ActionController::TestCase

  test "get edo members with valid data" do
    edo = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": [{"id":4,"trading_name": "Parameswara Traders","registration_contact":"Business Administrator","description":"trading","year_founded":"2001","ownership_type":"Public Company","anzsic_classification":["Division E - Construction"],"locations_attributes":[],"country_identifiers":[],"insurance_coverages":[],"certifications":[]}]}
    @request.headers['SERVICE']="TSBE"

    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}/members?with_organisation").to_return(status: [200], body: edo.to_json, headers: {})
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns&with_organization").to_return(status: [200], body: edo[:group].to_json, headers: {})
    get :members, format: 'text/json',params:{id:groups(:one).id}
    assert_response 200
    assert JSON.parse(@response.body)["edo"]["organizations"].length, 1
    assert_includes @response.body, "Parameswara Traders"
  end

end
