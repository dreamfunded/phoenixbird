class FundAmericaPayment

    def initialize(params, current_user, ip)
        @user = current_user
        @date_of_birth = params[:birth_date] + '/' + params[:birth_month] + '/' + params[:birth_year]
        @city = params[:city],
        @country = 'US',
        @email = current_user.email,
        @name = params[:name],
        @phone = params[:phone],
        @postal_code = params[:zipcode],
        @region = params[:state],
        @street_address_1 = params[:address],
        @tax_id_number = params[:ssn],
        @type = "person",
        @date_of_birth = @date_of_birth

        @name_on_account = params[:name],
        @account_number = params[:account_number],
        @routing_number = params[:routing_number],
        @account_type = params[:account_type],
        @check_type = params[:check_type],
        @email = params[:email],
        #@entity_id = entity['id'],
        @ip_address = ip
        @literal = "Test User",
        @phone = params[:phone],
        @address = params[:address],
        @city = params[:city],
        @state = params[:state],
        @zip_code = params[:zipcode]

        @amount = params[:amount],
        @equity_share_count = params[:amount],
        #offering_id: company.offering_code,
        @payment_method = "ach",
        #@entity_id = entity["id"],
        #@ach_authorization_id = ach["id"]

        @error = {}
        @entity, @ach_authorization = {}, {}
    end

    def entity
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
        return [@entity, @error]
    end

    def ach
    end

    def investment
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

end
