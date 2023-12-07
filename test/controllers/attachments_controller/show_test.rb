require 'test_helper'

class AttachmentsController::ShowTest < ActionController::TestCase

  test "get attachment with unauthorized" do

    get :show, format: 'text/json', params:{id:1}
    assert_response 401
  end

  # test "get attachment with valid data" do
  #   data=  {id:1, name:"file123" }
  #   @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
  #   @request.headers['SERVICE']="TSBE"

  #   edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
  #   stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/2?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
  #   stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:three).id}.to_json,headers:{})
  #   stub_request(:get, SystemConfig.get('comm/host') + "/attachments/1?comm_id=1&recipient_id=#{users(:four).id}&recipient_type=User&service_name=EDOC-TSBE&user_id=#{users(:four).id}&which=file").to_return(status: [200], body: data.to_json, headers: {})

  #   get :show, format: 'text/json', params:{id:1,comm_id:1}
  #   assert_response 200
  #   assert_includes @response.body,"file123"
  # end

  # test "get attachment with error from comm" do
  #   @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
  #   @request.headers['SERVICE']="TSBE"

  #   edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
  #   stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/2?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
  #   stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:three).id}.to_json,headers:{})
  #   stub_request(:get, SystemConfig.get('comm/host') + "/attachments/1?comm_id=1&recipient_id=#{users(:four).id}&recipient_type=User&service_name=EDOC-TSBE&user_id=#{users(:four).id}&which=file").to_return(status: [500,"Internal Server Error"])

  #   get :show, format: 'text/json', params:{id:1,comm_id:1}
  #   assert_response 422
  #   assert_includes @response.body,"Cannot download attachment"
  # end
end
