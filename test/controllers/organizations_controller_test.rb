require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase


  test "get organization with valid data" do
    organization={"id":4,"trading_name": "Parameswara Traders","registration_contact":"Business Administrator","description":"trading","year_founded":"2001","ownership_type":"Public Company","anzsic_classification":["Division E - Construction"],"locations_attributes":[],"country_identifiers":[],"insurance_coverages":[],"certifications":[]}
    @request.headers['SERVICE']="TSBE"

    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:get,  SystemConfig.get('ecx/host') + "/business/profile/get_organization?ECX_API=983ad8f7d05c021bfeab4be7173a7990&access_level=edo&columns&id=1").to_return(status:200,body:organization.to_json,headers:{})
    get :show, format: 'text/json',params:{id:1}
    assert_response 200
    assert_includes @response.body, "Parameswara Traders"
  end

  test "get organization with invalid response from ecx" do
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:get,  SystemConfig.get('ecx/host') + "/business/profile/get_organization?ECX_API=983ad8f7d05c021bfeab4be7173a7990&access_level=edo&columns&id=1").to_return(status:[500,"Internal Server Error"])
    get :show, format: 'text/json',params:{id:1}
    assert_response 422
    assert_includes @response.body, "Unable to get Organization Details"
  end

end
