require 'test_helper'

class NotificationsController::UpdateTest < ActionController::TestCase

  test "update notification with unauthorized" do
    params = {"id" => "5", "notification_type" => "market_request", "notification_id" => "5", "notified_by_id" => "#{users(:four).id}", "notified_at" => "2018-01-31 00:32:32.199095", "comm_id" => "1"}
    put :update, format: 'text/json', params: params
    assert_response 401
  end


  test "update notification with unknown Id" do
    params = {"id" => "125", "notification_type" => "market_request", "notification_id" => "5", "notified_by_id" => "#{users(:four).id}", "notified_at" => "2018-01-31 00:32:32.199095", "comm_id" => "1"}
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION'] = "SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200], body: {user_id: users(:four).id}.to_json, headers: {})
    begin
      put :update, format: 'text/json', params: params
    rescue ActiveRecord::RecordNotFound => exception
      assert_includes exception.message, "Couldn't find Notification with 'id'=125"
    end
  end


  test "update notification with success response" do
    params ={id:5,notification: {"id" => "5", "notification_type" => "market_request", "notification_id" => "5","group_id" => "187","notified_by_id" => "#{users(:four).id}", "notified_at" => "2018-01-31 00:32:32.199095", "comm_id" => "1"}}
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    edo_data = {"id": groups(:one).group_id, "name": "TSBE", "expansion": "Toowoomba & Surat Basin Enterprise", "group_levels": [], "organizations": []}
    stub_request(:get, SystemConfig.get('ecx/host') + "/business/groups/#{groups(:one).group_id}?ECX_API=983ad8f7d05c021bfeab4be7173a7990&columns=name&with_organization").to_return(status: [200], body: edo_data.to_json, headers: {})
    mr={:id=>356, :service=>"EconomX", :released_at=>"2017-11-30T06:24:07.896Z", :project_id=>1, :publish_date=>"2017-11-30T06:26:53.000Z", :closing_date=>"2017-12-14T06:23:53.000Z", :status=>"published", :form_id=>1017, :created_at=>"2017-11-30T06:08:19.839Z", :updated_at=>"2017-11-30T06:26:55.256Z", :package_type=>"market_enquiry", :creator=>{:id=>"1", :name=>"Vijaya Donepudi", :email=>"vijaya.donepudi@strategenics.com.au", :business_id=>"1"}, :location_attributes=>{:id=>10, :address=>"121 Princes Hwy, Corrimal NSW 2518, Australia", :status=>"active"}, :selected_organizations=>{:to_registered_interest=>true, :members=>[], :taxonomies=>[]}, :match_condition=>"All", :ideal_response_submitted=>true, :evaluation_status=>"not_started", :form=>{:id=>1017, :title=>"Sample test Project", :description=>"drafting", :created_at=>"2017-11-30T06:08:19.897Z", :updated_at=>"2017-11-30T06:23:41.867Z", :service=>"MR"}}
    stub_request(:get, SystemConfig.get('mr/host') + "/market_requests/5?without_elements=false").to_return(status: [200], body: mr.to_json, headers: {})
    comms={comm:{ id:"1",comm_type:"Notice", org_recipients:[{"id"=>3, "type"=>"Organization"}], user_recipients: [],form_data:{"id"=>1055, "form_id"=>1, "created_at"=>"2018-02-15T02:07:32.030Z", "updated_at"=>"2018-02-15T02:07:32.030Z", "elements"=>[{"id"=>4638, "type"=>"field", "priority"=>0, "entity"=>{"id"=>2464, "name"=>"subject", "label"=>"Subject", "field_type"=>"input", "min"=>0, "max"=>200, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice1234"}}, {"id"=>4639, "type"=>"field", "priority"=>1, "entity"=>{"id"=>2465, "name"=>"notice_text", "label"=>"Notice Text", "field_type"=>"textarea", "min"=>0, "max"=>4000, "required"=>true, "default"=>"Enter Text", "tooltip"=>"", "help_text"=>"", "data"=>"notice"}}, {"id"=>4640, "type"=>"field", "priority"=>3, "entity"=>{"id"=>2467, "name"=>"attachment", "label"=>"Attachment(s)", "field_type"=>"file", "min"=>0, "max"=>0, "required"=>false, "default"=>"", "tooltip"=>"", "help_text"=>"", "single"=>false, "data"=>nil}}, {"id"=>4641, "type"=>"field", "priority"=>2, "entity"=>{"id"=>2466, "name"=>"notice_type", "label"=>"Notice Type", "field_type"=>"select", "min"=>0, "max"=>0, "required"=>true, "default"=>"General", "tooltip"=>"", "help_text"=>"", "single"=>true, "choices"=>["General", "Feedback"], "data"=>"General"}}], "title"=>"Notice", "description"=>""}}}
    # stub_request(:get, SystemConfig.get('comm/host') + "/comms/1?service_name=EDOC-TSBE").to_return(status: [200],body:comms.to_json)
    
    Comms::GetComm.stubs(:call).returns(OpenStruct.new({ success?: true, comm: comms[:comm] }))
    put :update, format: 'text/json', params:params
    assert_response 200
    assert_includes @response.body,"purni@gmail.com"
  end



  test "update notification with update error" do
    params = {id:5,notification:{"id" => "4", "notification_type" => "market_request","group_id" => "187"}}
    @request.headers['SERVICE']="TSBE"

    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    mr={:id=>356, :service=>"EconomX", :released_at=>"2017-11-30T06:24:07.896Z", :project_id=>1, :publish_date=>"2017-11-30T06:26:53.000Z", :closing_date=>"2017-12-14T06:23:53.000Z", :status=>"published", :form_id=>1017, :created_at=>"2017-11-30T06:08:19.839Z", :updated_at=>"2017-11-30T06:26:55.256Z", :package_type=>"market_enquiry", :creator=>{:id=>"1", :name=>"Vijaya Donepudi", :email=>"vijaya.donepudi@strategenics.com.au", :business_id=>"1"}, :location_attributes=>{:id=>10, :address=>"121 Princes Hwy, Corrimal NSW 2518, Australia", :status=>"active"}, :selected_organizations=>{:to_registered_interest=>true, :members=>[], :taxonomies=>[]}, :match_condition=>"All", :ideal_response_submitted=>true, :evaluation_status=>"not_started", :form=>{:id=>1017, :title=>"Sample test Project", :description=>"drafting", :created_at=>"2017-11-30T06:08:19.897Z", :updated_at=>"2017-11-30T06:23:41.867Z", :service=>"MR"}}
    stub_request(:get, SystemConfig.get('mr/host') + "/market_requests/4?without_elements=false").to_return(status: [200], body: mr.to_json, headers: {})
    begin
      put :update, format: 'text/json', params: params
    rescue ActiveRecord::RecordInvalid => exception
      assert_includes exception.message, "Validation failed: Notified at is required, Notified by ID is required, Comm ID is required"
    end
  end

end
