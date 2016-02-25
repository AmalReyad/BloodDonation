require 'test_helper'

class WebservicesControllerTest < ActionController::TestCase
  setup do
    @webservice = webservices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webservices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webservice" do
    assert_difference('Webservice.count') do
      post :create, webservice: {  }
    end

    assert_redirected_to webservice_path(assigns(:webservice))
  end

  test "should show webservice" do
    get :show, id: @webservice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @webservice
    assert_response :success
  end

  test "should update webservice" do
    patch :update, id: @webservice, webservice: {  }
    assert_redirected_to webservice_path(assigns(:webservice))
  end

  test "should destroy webservice" do
    assert_difference('Webservice.count', -1) do
      delete :destroy, id: @webservice
    end

    assert_redirected_to webservices_path
  end
end
