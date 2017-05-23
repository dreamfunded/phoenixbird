require 'spec_helper'
require 'rails_helper'

describe HomeController do
    it "has a 200 status code" do
        get :index
        expect(response.status).to eq(200)
    end

end
