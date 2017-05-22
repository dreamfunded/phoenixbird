class FundAmericaPayment

    def initialize(params, current_user, ip, company)
        @user = current_user
        @date_of_birth = params[:birth_date] + '/' + params[:birth_month] + '/' + params[:birth_year]
        @city = params[:city]
        @country = 'US'
        @email = current_user.email
        @name = params[:name]
        @phone = params[:phone]
        @postal_code = params[:zipcode]
        @region = params[:state]
        @street_address_1 = params[:address]
        @tax_id_number = params[:ssn]
        @type = "person"
        @date_of_birth = @date_of_birth

        @ach = params[:ach]
        @company = company

        @name_on_account = params[:name]
        @account_number = params[:account_number]
        @routing_number = params[:routing_number]
        @account_type = params[:account_type]
        @check_type = params[:check_type]
        @email = params[:email]
        #@entity_id = entity['id']
        @ip_address = ip
        @literal = "Test User"
        @phone = params[:phone]
        @address = params[:address]
        @city = params[:city]
        @state = params[:state]
        @zip_code = params[:zipcode]

        @amount = params[:amount]
        @equity_share_count = params[:amount]
        #offering_id: company.offering_code
        @payment_method = "ach"
        #@entity_id = entity["id"]
        #@ach_authorization_id = ach["id"]

        @error = {}
        @entity, @ach_authorization = {}, {}
    end

    def make_payment

        if @user.entity_id
            begin
                @entity = FundAmerica::Entity.update(@user.entity_id, options)
            rescue FundAmerica::Error => e
                p 'ERROR'
                @entity, @ach_authorization = {}, {}
                puts e.parsed_response
                @error = e.parsed_response
            end
        else
            begin
                @entity = FundAmerica::Entity.create(options)
            rescue FundAmerica::Error => e
                p 'ERROR'
                puts e.parsed_response
                @error = e.parsed_response
            end
        end


        if @entity
            @user.update(entity_id: @entity["id"])
            if @ach == 'exist'
                @ach_authorization = FundAmerica::AchAuthorization.details( @user.ach_id )
            else
                ach_auth_options = get_ach_options( @entity)
                begin
                    @ach_authorization = FundAmerica::AchAuthorization.create(ach_auth_options)
                    p "ACH"
                    p @ach_authorization
                rescue FundAmerica::Error => e
                    p 'ERROR'
                    puts e.parsed_response
                    @error = @error.merge(e.parsed_response)
                end
            end
        end

        if @entity && @ach_authorization
            @user.update(ach_id: @ach_authorization["id"] )
            investment_options = get_investment_options( @company, @entity, @ach_authorization)
            begin
                @investment = FundAmerica::Investment.create(investment_options)
                ContactMailer.investment_made( @user).deliver
                ContactMailer.new_investment_made(@user, @company.id).deliver
                ContactMailer.new_investment_to_founder(@company.id).deliver
            rescue FundAmerica::Error => e
                p 'ERROR'
                puts e.parsed_response
                @error = @error.merge(e.parsed_response)
            end
            p "INVESTMENT"
            p @investment
        end

        return [@investment, @error, @entity, @ach_authorization]
    end



    def options
        options = {
           :city => @city,
           :country => 'US',
           :email => @user.email,
           :name => @name,
           :phone => @phone,
           :postal_code => @postal_code,
           :region => @region,
           :street_address_1 => @street_address_1,
           :tax_id_number => @tax_id_number,
           :type => "person",
           :date_of_birth => @date_of_birth
        }
    end

    def get_ach_options( entity)
        get_ach_options = {
          :name_on_account => @name_on_account,
          :account_number => @account_number,
          :routing_number => @routing_number,
          :account_type => @account_type,
          :check_type => @check_type,
          :email => @email,
          :entity_id => entity['id'],
          :ip_address => @ip_address,
          :literal => "Test User",
          :phone => @phone,
          :address => @address,
          :city => @city,
          :state => @state,
          :zip_code => @zip_code
        }
    end

    def get_investment_options(company, entity, ach)
        investment_options = {
            amount: @amount,
            equity_share_count: @amount,
            offering_id: company.offering_code,
            payment_method: "ach",
            entity_id: entity["id"],
            ach_authorization_id: ach["id"]
        }
    end

end
