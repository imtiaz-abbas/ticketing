Resolving dependencies...
require "twilio-ruby"

class Twilio::Sms
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  attr_accessor :message, :to_number, :account_sid, :auth_token, :messaging_phone_number

  before_validation :setup_api_key

  def setup_api_key
    self.account_sid ||= ENV["TWILIO_ACCOUNT_SID"]
    self.auth_token ||= ENV["TWILIO_AUTH_TOKEN"]
    self.messaging_phone_number ||= ENV["TWILIO_MESSAGING_PHONE_NUMBER"]
  end

  def send_sms
    return nil if invalid?
    client = Twilio::REST::Client.new(account_sid, auth_token)
    client.messages.create(
      from: messaging_phone_number,
      body: message,
      to: to_number,
    )
  end
end
