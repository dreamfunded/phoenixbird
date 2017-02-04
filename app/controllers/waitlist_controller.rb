class WaitlistController < ApplicationController
    before_action :set_company, only: [ :join_waitlist, :reg_a_company, :waitlist, :join_waitlist_send_email_with_invest]

    #extract in a waitlist controller
    def join_waitlist
    end

    #extract in a waitlist controller
    def join_waitlist_send_email
        company_name = params[:company_name]
        @name = params[:name]
        @email = params[:email]
        @phone = params[:phone]
        @message = params[:message]
        Guest.create(email: params[:email], company: company_name, user_id: current_user.id)
        ContactMailer.contact_us_email(@name, @email, @phone, @message).deliver
        flash[:thank_you_notice] = 'Thank you'
        redirect_to "/join_waitlist_thank_you"
    end

    def join_waitlist_send_email_with_invest
        company_name = @company.name
        Guest.create(email: current_user.email, company: company_name, user_id: current_user.id)
        ContactMailer.join_waitlist_with_invest(@company, current_user, params[:invest_amount]).deliver
        redirect_to "/join_waitlist_thank_you"
    end

    #extract in a waitlist controller
    def join_waitlist_thank_you
    end

    #extract in a waitlist controller
    def waitlist
    end

    #extract in a waitlist controller
    def join_waitlist_reg_a
        company_name = params[:company_name]
        @name = params[:name]
        @email = params[:email]
        @phone = params[:phone]
        @amount = params[:amount]
        @message = params[:message]
        Guest.create(email: params[:email], company: company_name, user_id: current_user.id)
        ContactMailer.waitlist(@name, @email, @phone, @amount, @message).deliver
        flash[:thank_you_notice] = 'Thank you'
        redirect_to "/join_waitlist_thank_you"
    end


private
    def set_company
      @company = Company.friendly.find(params[:id])
    end
end
