class NotificationsController < ApplicationController 
    skip_before_action :verify_authenticity_token

    @@gifs = [
        "https://media3.giphy.com/media/GwOVvsMGbU0dG/giphy.gif?cid=ecf05e47xm6wt1bg32okrmkn3y2pdew8xm962j7dcufmxttb&rid=giphy.gif&ct=g",
        "https://media0.giphy.com/media/0OgdJVNjbcIifqSb7U/giphy.gif?cid=ecf05e47aa2cb667936002cdfd5abb0878ea168604c8edd9&rid=giphy.gif&ct=g",
        "https://media2.giphy.com/media/BaSnOKasWWNig/giphy.gif?cid=ecf05e471t4lyah4990twfwnw5878n2xeg2l9vyhto0kfjcl&rid=giphy.gif&ct=g",
        "https://media0.giphy.com/media/MAuWrJTykDWvUlZ8Ef/giphy.gif?cid=ecf05e471id5f05rlkwaezugheppcxiedwvf9uqu3kztjw02&rid=giphy.gif&ct=g",
        "https://media0.giphy.com/media/rrZIZOMy4xL1e/giphy.gif?cid=ecf05e47naaa7bkmf4gewdm0u0it9ym6j6inm9tpnk99ho1h&rid=giphy.gif&ct=g",
        "https://media4.giphy.com/media/3oEduTc1ImDHt8hoJy/giphy.gif?cid=ecf05e47x8dg28rz0mnvgurceqw45ztns6qnz75pyksc3f6v&rid=giphy.gif&ct=g",
        "https://media4.giphy.com/media/eSwGh3YK54JKU/giphy.gif?cid=ecf05e47i1zac8hdgx6dr82sohmxbshyaozekpm12hxduq73&rid=giphy.gif&ct=g",
        "https://media0.giphy.com/media/2QHLYZFJgjsFq/giphy.gif?cid=ecf05e47vuwzcgidfjcxzgnnck5rmgqg58n4rijig5eo073s&rid=giphy.gif&ct=g",
        "https://media4.giphy.com/media/E9zwx0N8EPvyw/giphy.gif?cid=ecf05e47d81dwvrkzpc5cgeoxr2areuvitjho9edr8mh2qo7&rid=giphy.gif&ct=g",
        "https://media1.giphy.com/media/7JkdvxxsXXeskAxyjT/giphy.gif?cid=ecf05e47n5u4zje5va13jcgykruukijznq7m3t12hzgxav7t&rid=giphy.gif&ct=g",
        "https://media4.giphy.com/media/3NJOSauG33a6c/giphy.gif?cid=ecf05e47fpnbtz1j8vf8v4xmuyo53nbm9nmyppospix933e4&rid=giphy.gif&ct=g"
    ]

    def notify
        client = Twilio::REST::Client.new(Rails.application.config.twilio_account_sid, Rails.application.config.twilio_auth_token)

        begin
            body = params['Body']
            reminder_parts = body.split(" @ ")
            person_to_contact = Contact.find_by(name: reminder_parts[0]) 

            return unless person_to_contact.present? 

            to = person_to_contact.phone_number
            reminder_text = reminder_parts[1]
            notification_date = Time.parse(reminder_parts[2])

            message = client.messages
            .create(
              messaging_service_sid: 'MG7d9df92daec8cff46c91ba1e019bf2f3',
              body: reminder_text,
              send_at: notification_date,
              schedule_type: 'fixed',
              status_callback: request.base_url + '/twilio/status',
              media_url: [select_random_gif(@@gifs)],
              to: to
            )

            if message.present? 
                Message.create(
                    body: reminder_text, 
                    to_contact_id: person_to_contact.id, 
                    from_contact_id: Contact.find_by(name: "Chris").id,
                    twilio_id: message.sid, 
                    status: message.status,
                    scheduled_time: notification_date
                )
            end 
        rescue NoMethodError, TypeError
            twiml = Twilio::TwiML::MessagingResponse.new do |resp|
              if body.strip.downcase == 'veli nice'
                resp.message body: 'sickkkk'
              else 
                resp.message body: 'this program is dumb it does not understand what you said'
              end
            end
        end  
    end

    private 

    def select_random_gif(gifs)
        index = rand(gifs.length)
        gifs[index]
    end 
end 