class CustomFailure < Devise::FailureApp
  def respond
    self.status = 401
    self.headers['WWW-Authenticate'] = %(Basic realm=#{Devise.http_authentication_realm.inspect}) if http_auth_header?
    self.content_type = 'json'
    self.response_body = '{"errors": "not authenticated"}'
  end
end
