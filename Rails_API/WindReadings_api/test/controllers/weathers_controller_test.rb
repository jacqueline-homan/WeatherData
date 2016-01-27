require 'test_helper'

class WeathersControllerTest < ActionController::TestCase
  setup do
    @weather = weathers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weathers)
  end

  test "should create weather" do
    assert_difference('Weather.count') do
      post :create, weather: { end_date: @weather.end_date, start_date: @weather.start_date }
    end

    assert_response 201
  end

  test "should show weather" do
    get :show, id: @weather
    assert_response :success
  end

  test "should update weather" do
    put :update, id: @weather, weather: { end_date: @weather.end_date, start_date: @weather.start_date }
    assert_response 204
  end

  test "should destroy weather" do
    assert_difference('Weather.count', -1) do
      delete :destroy, id: @weather
    end

    assert_response 204
  end
end
