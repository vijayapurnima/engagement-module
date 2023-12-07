require 'test_helper'

class CommsController::NotifyTest < ActionController::TestCase

  test "notify comm with unauthorized" do
    params={"id"=>"179", "comm_type"=>"Notice", "recipients"=>[{"id"=>3, "type"=>"Organization"}], "form_data"=>{"id"=>1055, "form_id"=>1, "created_at"=>"2018-02-15T02:07:32.030Z", "updated_at"=>"2018-02-15T02:07:32.030Z", "elements"=>[{"id"=>4638, "type"=>"field", "priority"=>0, "entity"=>{"id"=>2464, "name"=>"subject", "label"=>"Subject", "field_type"=>"input", "min"=>0, "max"=>200, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice1234"}}, {"id"=>4639, "type"=>"field", "priority"=>1, "entity"=>{"id"=>2465, "name"=>"notice_text", "label"=>"Notice Text", "field_type"=>"textarea", "min"=>0, "max"=>4000, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice"}}, {"id"=>4640, "type"=>"field", "priority"=>3, "entity"=>{"id"=>2467, "name"=>"attachment", "label"=>"Attachment(s)", "field_type"=>"file", "min"=>0, "max"=>0, "required"=>false, "default"=>"", "tooltip"=>"", "help_text"=>"", "single"=>false, "data"=>nil}}, {"id"=>4641, "type"=>"field", "priority"=>2, "entity"=>{"id"=>2466, "name"=>"notice_type", "label"=>"Notice Type", "field_type"=>"select", "min"=>0, "max"=>0, "required"=>true, "default"=>"General", "tooltip"=>"", "help_text"=>"", "single"=>true, "choices"=>["General", "Feedback"], "data"=>"General"}}], "title"=>"Notice", "description"=>""}}
    post :notify_members, format: 'text/json', params:params
    assert_response 401
  end

  test "notify comm with success response from send and on notify" do
    params={id:17,comm:{ "id"=>"17","comm_type"=>"Notice123", "recipients"=>[{"id"=>3, "type"=>"Organization"}], "form_data"=>{"id"=>1055, "form_id"=>1, "created_at"=>"2018-02-15T02:07:32.030Z", "updated_at"=>"2018-02-15T02:07:32.030Z", "elements"=>[{"id"=>4638, "type"=>"field", "priority"=>0, "entity"=>{"id"=>2464, "name"=>"subject", "label"=>"Subject", "field_type"=>"input", "min"=>0, "max"=>200, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice1234"}}, {"id"=>4639, "type"=>"field", "priority"=>1, "entity"=>{"id"=>2465, "name"=>"notice_text", "label"=>"Notice Text", "field_type"=>"textarea", "min"=>0, "max"=>4000, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice"}}, {"id"=>4640, "type"=>"field", "priority"=>3, "entity"=>{"id"=>2467, "name"=>"attachment", "label"=>"Attachment(s)", "field_type"=>"file", "min"=>0, "max"=>0, "required"=>false, "default"=>"", "tooltip"=>"", "help_text"=>"", "single"=>false, "data"=>nil}}, {"id"=>4641, "type"=>"field", "priority"=>2, "entity"=>{"id"=>2466, "name"=>"notice_type", "label"=>"Notice Type", "field_type"=>"select", "min"=>0, "max"=>0, "required"=>true, "default"=>"General", "tooltip"=>"", "help_text"=>"", "single"=>true, "choices"=>["General", "Feedback"], "data"=>"General"}}], "title"=>"Notice", "description"=>""}}}
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    stub_request(:get, SystemConfig.get('comm/host') + "/comms/17?service_name=EDOC-TSBE").to_return(status: [200],body:params.to_json)
    Comms::GetComm.stubs(:call).returns(OpenStruct.new({ success?: true, comm: params[:comm] }))
    Comms::SendComm.stubs(:call).returns(OpenStruct.new({ success?: true, comm: params[:comm] }))
    Comms::NotifyUsers.stubs(:call).returns(OpenStruct.new({ success?: true }))

    post :notify_members, format: 'text/json', params:params
    assert_response 200
    assert_includes @response.body,"Notice123"
  end

  test "notify comm with success response from send but error on notify" do
    params={id:17,comm:{ "id"=>"17","comm_type"=>"Notice123", "recipients"=>[{"id"=>3, "type"=>"Organization"}], "form_data"=>{"id"=>1055, "form_id"=>1, "created_at"=>"2018-02-15T02:07:32.030Z", "updated_at"=>"2018-02-15T02:07:32.030Z", "elements"=>[{"id"=>4638, "type"=>"field", "priority"=>0, "entity"=>{"id"=>2464, "name"=>"subject", "label"=>"Subject", "field_type"=>"input", "min"=>0, "max"=>200, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice1234"}}, {"id"=>4639, "type"=>"field", "priority"=>1, "entity"=>{"id"=>2465, "name"=>"notice_text", "label"=>"Notice Text", "field_type"=>"textarea", "min"=>0, "max"=>4000, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice"}}, {"id"=>4640, "type"=>"field", "priority"=>3, "entity"=>{"id"=>2467, "name"=>"attachment", "label"=>"Attachment(s)", "field_type"=>"file", "min"=>0, "max"=>0, "required"=>false, "default"=>"", "tooltip"=>"", "help_text"=>"", "single"=>false, "data"=>nil}}, {"id"=>4641, "type"=>"field", "priority"=>2, "entity"=>{"id"=>2466, "name"=>"notice_type", "label"=>"Notice Type", "field_type"=>"select", "min"=>0, "max"=>0, "required"=>true, "default"=>"General", "tooltip"=>"", "help_text"=>"", "single"=>true, "choices"=>["General", "Feedback"], "data"=>"General"}}], "title"=>"Notice", "description"=>""}}}
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    Comms::GetComm.stubs(:call).returns(OpenStruct.new({ success?: true, comm: params[:comm] }))
    stub_request(:post, SystemConfig.get('comm/host') + "/send_comm").to_return(status: [200],body:params.to_json)
    stub_request(:post, SystemConfig.get('ecx/host') + "/notify_users").to_return(status: [500, "Internal Server Error"])

    post :notify_members, format: 'text/json', params:params
    assert_response 422
    assert_includes @response.body,"Cannot notify Business Users"
  end



  test "notify comm with error response from send" do
    params={id:17,comm: {"id"=>"17","comm_type"=>"Notice", "recipients"=>[{"id"=>3, "type"=>"Organization"}], "form_data"=>{"id"=>1055, "form_id"=>1, "created_at"=>"2018-02-15T02:07:32.030Z", "updated_at"=>"2018-02-15T02:07:32.030Z", "elements"=>[{"id"=>4638, "type"=>"field", "priority"=>0, "entity"=>{"id"=>2464, "name"=>"subject", "label"=>"Subject", "field_type"=>"input", "min"=>0, "max"=>200, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice1234"}}, {"id"=>4639, "type"=>"field", "priority"=>1, "entity"=>{"id"=>2465, "name"=>"notice_text", "label"=>"Notice Text", "field_type"=>"textarea", "min"=>0, "max"=>4000, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice"}}, {"id"=>4640, "type"=>"field", "priority"=>3, "entity"=>{"id"=>2467, "name"=>"attachment", "label"=>"Attachment(s)", "field_type"=>"file", "min"=>0, "max"=>0, "required"=>false, "default"=>"", "tooltip"=>"", "help_text"=>"", "single"=>false, "data"=>nil}}, {"id"=>4641, "type"=>"field", "priority"=>2, "entity"=>{"id"=>2466, "name"=>"notice_type", "label"=>"Notice Type", "field_type"=>"select", "min"=>0, "max"=>0, "required"=>true, "default"=>"General", "tooltip"=>"", "help_text"=>"", "single"=>true, "choices"=>["General", "Feedback"], "data"=>"General"}}], "title"=>"Notice", "description"=>""}}}
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    @request.headers['SERVICE']="TSBE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    Comms::GetComm.stubs(:call).returns(OpenStruct.new({ success?: true, comm: params[:comm] }))
    Comms::SendComm.stubs(:call).returns(OpenStruct.new({ failure?: true, message: 'Cannot send comm' }))
    
    post :notify_members, format: 'text/json', params:params
    assert_response 422
    assert_includes @response.body,"Cannot send comm"
  end

end
