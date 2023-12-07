require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase


  test "get project with valid data" do
    project_columns = %w(id name organization_id)
    project={"id":1,"name":"Carmichael Project123","director_id":nil,"commercial_manager_id":nil,"cost_code":nil,"location":nil,"time_frame":nil,"description":"The $16.5 bn Adani Carmichael Coal Project includes the development of a thermal coal mine, the construction of a 388 km standard gauge rail line and the proposed expansion of the Adani owned and operated Abbot Point Port.\n\nThe coal from the Carmichael Coal Project will be used in power stations across India and will replace less efficient coal currently sourced from Indonesia and India.\n\nIf you are interested in learning more about the Project please register your interest below. During that process we will ask you some specific questions which will help us develop our Local and Regional Content strategy.\n\nSpecific opportunities from the project will be made visible as they arise and you be able to access them via the Search Packages button which you’ll find on the Home Page1234.\n\nhttps://strategenics.atlassian.net/secure/RapidBoard.jspa?rapidView=32\u0026projectKey=ECX\nhttps://strategenics.atlassian.net/secure/RapidBoard.jspa?rapidView=32\u0026projectKey=ECX.https://strategenics.atlassian.net","register_interest_form_id":289,"created_at":"2017-07-11T00:24:52.434Z","updated_at":"2018-01-18T04:36:39.305Z","logo_id":3,"form_id":72,"organization_id":1,"parent_id":nil,"status":"active","register_interest_package_id":192}
    @request.headers['SERVICE']="TSBE"
    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:get,  SystemConfig.get('ecx/host') + "/projects/4?columns%5B%5D=id&columns%5B%5D=name&columns%5B%5D=organization_id").to_return(status:200,body:project.to_json,headers:{})
    get :show, format: 'text/json',params:{id:4,columns: project_columns}
    assert_response 200
    assert_includes @response.body, "Carmichael Project123"
  end

  test "get project with invalid response from ecx" do
    project_columns = %w(id name organization_id)
    @request.headers['SERVICE']="TSBE"

    @request.headers['HTTP_AUTHORIZATION']="SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE"
    stub_request(:get, SystemConfig.get('auth/host') + "/auth_session?service_name=EDOC-TSBE&token=SFMyNTY.g3QAAAACZAAEZGF0YWEHZAAGc2lnbmVkbgYAXWYDh2EB.Qkusp6Jnc4chA_KsoLVJOD5Bfy_JixAgKS_mMl3doAE").to_return(status: [200],body: {user_id:users(:four).id}.to_json,headers:{})
    stub_request(:get,  SystemConfig.get('ecx/host') + "/projects/4?columns%5B%5D=id&columns%5B%5D=name&columns%5B%5D=organization_id").to_return(status:[500,"Internal Server Error"])
    get :show, format: 'text/json',params:{id:4, columns: project_columns}
    assert_response 422
    assert_includes @response.body, "Unable to get Project details"
  end
end
