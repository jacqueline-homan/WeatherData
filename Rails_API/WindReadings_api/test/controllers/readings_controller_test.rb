require 'test_helper'

class ReadingsControllerTest < ActionController::TestCase
  setup do
    @reading = readings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:readings)
  end

  test "should create reading" do
    assert_difference('Reading.count') do
      post :create, reading: { date_range: @reading.date_range, end_date: @reading.end_date, start_date: @reading.start_date }
    end

    assert_response 201
  end

  test "should show reading" do
    get :show, id: @reading
    assert_response :success
  end

  test "should update reading" do
    put :update, id: @reading, reading: { date_range: @reading.date_range, end_date: @reading.end_date, start_date: @reading.start_date }
    assert_response 204
  end

  test "should destroy reading" do
    assert_difference('Reading.count', -1) do
      delete :destroy, id: @reading
    end

    assert_response 204
  end
end
