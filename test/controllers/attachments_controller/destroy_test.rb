require 'test_helper'

class AttachmentsController::CreateTest < ActionController::TestCase

  test "destroy attachment with unauthorized" do
    get :destroy, format: 'text/json', params:{id:4,comm_id:1}
    assert_response 401
  end

  test "destroy attachment with success response from comm" do
    params={ attachment_type:"file",linked_to_id:1, linked_to_type: "Communication"}
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:delete, SystemConfig.get('comm/host') + "/attachments/4?service_name=EDOC-TSBE&user_id=4&user_id=#{users(:four).id}&comm_id=1").to_return(status: [200])

    get :destroy, format: 'text/json', params:{id:4,comm_id:1}
    assert_response 200
  end

  test "destroy attachment with error response from comm" do
    params={ attachment_type:"file",linked_to_id:1, linked_to_type: "Communication"}
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})

    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:delete, SystemConfig.get('comm/host') + "/attachments/4?service_name=EDOC-TSBE&user_id=4&user_id=#{users(:four).id}&comm_id=1").to_return(status: [500,"Internal Service Error"])

    get :destroy, format: 'text/json', params:{id:4,comm_id:1}
    assert_response 422
    assert_includes @response.body,"Cannot destroy attachment"

  end
end
