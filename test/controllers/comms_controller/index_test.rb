require 'test_helper'

class CommsController::IndexTest < ActionController::TestCase
  test 'get comms with unauthorized' do
    params = { 'which' => 'drafts' }
    get :index, format: 'text/json', params: params
    assert_response 401
  end

  test 'get comms with success response' do
    params = { 'which' => 'drafts' }
    @request.headers['HTTP_AUTHORIZATION'] =
      'SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE'
    @request.headers['SERVICE'] = 'TSBE'
    stub_request(:get, SystemConfig.get('auth/host') + '/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE').to_return(
      status: [200], body: { user_id: users(:four).id }.to_json, headers: {}
    )
    User.stubs(:service_name).returns('TSBE')
    data = [{ "id": 179, "form_data_set_id": 1055, "last_saved": '2018-02-15T02:15:43.455Z', "comm_type": 'Notice',
              "form": { "id": 1055, "form_id": 1, "created_at": '2018-02-15T02:07:32.030Z', "updated_at": '2018-02-15T02:15:43.413Z', "elements": [{ "id": 4638, "type": 'field', "priority": 0, "entity": { "id": 2464, "name": 'subject', "label": 'Subject', "field_type": 'input', "min": 0, "max": 200, "required": true, "default": 'Enter Text', "tooltip": '', "help_text": '', "data": 'notice1' } }, { "id": 4639, "type": 'field', "priority": 1, "entity": { "id": 2465, "name": 'notice_text', "label": 'Notice Text', "field_type": 'textarea', "min": 0, "max": 4000, "required": true, "default": 'Enter Text', "tooltip": '', "help_text": '', "data": 'notice' } }, { "id": 4641, "type": 'field', "priority": 2, "entity": { "id": 2466, "name": 'notice_type', "label": 'Notice Type', "field_type": 'select', "min": 0, "max": 0, "required": true, "default": 'General', "tooltip": '', "help_text": '', "single": true, "choices": %w[General Feedback], "data": 'General' } }, { "id": 4640, "type": 'field', "priority": 3, "entity": { "id": 2467, "name": 'attachment', "label": 'Attachment(s)', "field_type": 'file', "min": 0, "max": 0, "required": false, "default": '', "tooltip": '', "help_text": '', "single": false, "data": nil } }], "title": 'Notice', "description": '' }, "org_recipients": [{ "id": 163, "comm_id": 179, "sent_to_id": 3, "sent_to_type": 'Organization' }], "user_recipients": [], "sender": { "id": '1', "name": 'Mrs.Vijaya', "email": 'vijaya@tsbe.com.au' }, "service_name": 'TSBE' }]
    stub_request(:get, SystemConfig.get('comm/host') + "/comms?which=drafts&user_id=#{users(:four).id}&service_name=EDOC-TSBE").to_return(
      status: [200], body: data.to_json
    )
    edo_data = { "id": groups(:one).group_id, "name": 'TSBE', "expansion": 'Toowoomba & Surat Basin Enterprise',
                 "group_type": groups(:one).group_type, "group_levels": [], "organizations": [] }
                 stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/187?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization")
      .to_return(status: 200, body: edo_data.to_json, headers: {})
    get :index, format: 'text/json', params: params
    assert_response 200
    assert_equal JSON.parse(@response.body)['comms'].length, 1
  end

  test 'get comms with error response' do
    params = { 'which' => 'drafts' }
    @request.headers['HTTP_AUTHORIZATION'] =
      'SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE'
    @request.headers['SERVICE'] = 'TSBE'
    stub_request(:get, SystemConfig.get('auth/host') + '/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE').to_return(
      status: [200], body: { user_id: users(:four).id }.to_json, headers: {}
    )
    User.stubs(:service_name).returns('TSBE')
    stub_request(:get,
                 SystemConfig.get('comm/host') + "/comms?which=drafts&user_id=#{users(:four).id}&service_name=EDOC-TSBE").to_return(status: [
                                                                                                                                      500, 'Internal Server Error'
                                                                                                                                    ])
    edo_data = { "id": groups(:one).group_id, "name": 'TSBE', "expansion": 'Toowoomba & Surat Basin Enterprise',
                 "group_type": groups(:one).group_type, "group_levels": [], "organizations": [] }
                 stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/187?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization")
      .to_return(status: 200, body: edo_data.to_json, headers: {})
    get :index, format: 'text/json', params: params
    assert_response 422
    assert_includes @response.body, 'Cannot get comm'
  end
end
