require 'test_helper'

class FormsController::ShowTest < ActionController::TestCase

  test "get form with unauthorized" do

    get :show, format: 'text/json', params:{id:1}
    assert_response 401
  end

  test "get form with valid response" do
    form=  {
        id: 1,
        title: "EOI Warning",
        description: ""

    }
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})

    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:get, SystemConfig.get('form/host') + "/forms/1?access_type=owner&service_name=EDOC-TSBE").to_return(status: [200], body: form.to_json, headers: {})

    get :show, format: 'text/json', params:{id:1}
    assert_response 200
    assert_includes @response.body,"EOI Warning"
  end
end
