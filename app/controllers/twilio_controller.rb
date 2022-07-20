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
    text_sent = params["Body"]

    render plain: "The text was #{status}"
  end 
end