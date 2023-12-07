require 'test_helper'

class NotificationsController::IndexTest < ActionController::TestCase

  test "get notifications with unauthorized" do
    params={"which"=>"un_notified","notification_type"=>"market_request"}
    get :index, format: 'text/json', params:params
    assert_response 401
  end


  test "get notifications with success response" do
    params={ "which"=>"un_notified","notification_type"=>"MarketRequest"}
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    mr={:id=>356, :service=>"EconomX", :released_at=>"2017-11-30T06:24:07.896Z", :project_id=>1, :publish_date=>"2017-11-30T06:26:53.000Z", :closing_date=>"2017-12-14T06:23:53.000Z", :status=>"published", :form_id=>1017, :created_at=>"2017-11-30T06:08:19.839Z", :updated_at=>"2017-11-30T06:26:55.256Z", :package_type=>"market_enquiry", :creator=>{:id=>"1", :name=>"Vijaya Donepudi", :email=>"vijaya.donepudi@strategenics.com.au", :business_id=>"1"}, :location_attributes=>{:id=>10, :address=>"121 Princes Hwy, Corrimal NSW 2518, Australia", :status=>"active"}, :selected_organizations=>{:to_registered_interest=>true, :members=>[], :taxonomies=>[]}, :match_condition=>"All", :ideal_response_submitted=>true, :evaluation_status=>"not_started", :form=>{:id=>1017, :title=>"Sample test Project", :description=>"drafting", :created_at=>"2017-11-30T06:08:19.897Z", :updated_at=>"2017-11-30T06:23:41.867Z", :service=>"MR"}}
    stub_request(:get, SystemConfig.get('mr/host') + "/market_requests/5?without_elements=true").to_return(status: [200], body: mr.to_json, headers: {})
    stub_request(:get, SystemConfig.get('mr/host') + "/market_requests/4?without_elements=true").to_return(status: [200], body: mr.to_json, headers: {})

    get :index, format: 'text/json', params:params
    assert_response 200
    assert_includes @response.body,"project_id"
  end
end