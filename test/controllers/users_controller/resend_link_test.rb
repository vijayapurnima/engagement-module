require 'test_helper'

class UsersController::ResendLinkTest < ActionController::TestCase

  # test "resend link with no email" do
  #   post :resend_link, format: 'text/json', params: {}
  #   assert_response 422
  #   assert_includes @response.body, "Email is required"
  # end

  # test "resend link for verified email" do
  #   post :resend_link, format: 'text/json', params: {email:'sanju@tsbe.com'}
  #   assert_response 200
  #   assert_nil User.find_by(email: 'purni@gmail.com').code
  # end
  #
  # test "resend link for unregistered email" do
  #   post :resend_link, format: 'text/json', params: {email:'vijaya@tsbe.in'}
  #   assert_response 200
  #   assert_nil User.find_by(email: 'vijaya@tsbe.in')
  # end

  test "resend link for valid registered email" do
    post :resend_link, format: 'text/json', params: {email:'vijji@gmail.com'}
    assert_response 200
    assert User.find_by(email: 'vijji@gmail.com').code
  end

end