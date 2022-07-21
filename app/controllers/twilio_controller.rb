require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  # This prevents CSRF detection from stopping twilio's POST requests to this endpoint 
  skip_before_action :verify_authenticity_token

  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there. Congrats on integrating Twilio into your Rails app.', :voice => 'alice'
         r.Play 'http://linode.rabasa.com/cantina.mp3'
    end

    render_twiml response
  end

  def status
    status = params["MessageStatus"]
    twilio_id = params["MessageSid"]
    incoming_message = Message.find_by(twilio_id: twilio_id)

    incoming_message.update(status: status) if incoming_message.present?

    head :no_content # 204
  end 
end