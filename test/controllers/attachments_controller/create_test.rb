require 'test_helper'

class AttachmentsController::CreateTest < ActionController::TestCase

  test "create attachment with unauthorized" do
    params={ attachment_type:"file",linked_to_id:1, linked_to_type: "Communication",file:"#<ActionDispatch::Http::UploadedFile:0x007fa4e83e8020 @tempfile=#<Tempfile:/var/folders/l8/_lpsq5kx7dx64bf4g0xw3sth0000gp/T/RackMultipart20180215-2865-d5h3kw.pdf>, @original_filename='Anutesting.pdf', @content_type='application/pdf, filename=\'Anutesting.pdf\\r\nContent-Type: 'application/pdf\r\n>" }
    post :create, format: 'text/json', params:params
    assert_response 401
  end



  test "create attachment with error" do
    params={ attachment_type:"file",linked_to_id:1, linked_to_type: "Communication"}
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})

    post :create, format: 'text/json', params:params
    assert_response 422
    assert_includes @response.body,"File,Attachment Type or Linked detail is missing"
  end
end
