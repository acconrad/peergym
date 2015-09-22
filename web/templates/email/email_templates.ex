defmodule PeerGym.EmailTemplates do
  def register_template(user) do
    """
      <h1>Welcome to PeerGym</h1>
      Thank you for signing up #{user.username}, time to get swole!
    """
  end

  def password_recovery_template(user) do
    """
      <h1>Lost your password?</h1>
      Bummer bro, we'll hook you up:
      <a href="http://peergym.com/recover_password?token=#{user.recovery_hash}">Save me</a>
    """
  end
end
