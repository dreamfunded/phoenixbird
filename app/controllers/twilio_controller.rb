class TwilioController < ApplicationController


    def sms_list
        send_message('6503915081', "Coffee Break?")
        redirect_to root_path
    end


    private
    def send_message(phone_number, message)
        @twilio_number = '+17073465370'
        @client = Twilio::REST::Client.new 'ACe980b495d80416c02dbd29a8e1624d11', '1ce457af9ddbdb32dfc1ddf198507abf'

        message = @client.account.messages.create(
           :from => @twilio_number,
           :to => phone_number,
           :body => message,
        )
        puts message.to
    end



end
