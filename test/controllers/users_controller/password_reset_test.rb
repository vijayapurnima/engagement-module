require 'test_helper'

class UsersController::PasswordResetTest < ActionController::TestCase


  test "reset password link with no email" do
    post :reset_password, format: 'text/json', params: {}
    assert_response 422
    assert_includes @response.body, "Email is required"
  end

  test "reset password link for verified email" do
    post :reset_password, format: 'text/json', params: {email: 'purni@gmail.com'}
    assert_response 200
    assert User.find_by(email: 'purni@gmail.com').code
  end

  test "reset password link for unregistered email" do
    post :reset_password, format: 'text/json', params: {email: 'vijaya@tsbe.in'}
    assert_response 200
    assert_nil User.find_by(email: 'vijaya@tsbe.in')
  end

  test "reset password link for valid registered email" do
    post :reset_password, format: 'text/json', params: {email: 'vijji@gmail.com'}
    assert_response 200
    assert_nil User.find_by(email: 'vijji@gmail.com').code
  end

end