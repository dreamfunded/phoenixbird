class Campaign < ActiveRecord::Base
  TESTIMONIALS_LIMIT = 3
  ACCESSIBLE_ATTRIBUTES = [
    :tagline, :elevator_pitch, :about_campaign,
    :id, :category, :employees_numer, :company_location_city,
    :company_location_state, :business_plan ]


  belongs_to :company
  has_many :events, class_name: "CampaignEvent"
  has_many :testimonials
  has_one :quote, class_name: 'CampaignQuote'
  accepts_nested_attributes_for :testimonials, reject_if: :all_blank, allow_destroy: true, limit: TESTIMONIALS_LIMIT
  accepts_nested_attributes_for :quote


  def location
    if self.submitted?
      self.company_location_address + ", " + self.company_location_city + ", " + self.company_location_state + ", "+ self.company_location_zipcode
    end
  end

  def place
    if self.submitted?
      self.company_location_city + ", " + self.company_location_state
    end

  end

  def finished?
    self.offering_terms?
  end


  STATES = %w[goal basics description legal financial complete]
  delegate :goal?, :basics?, :description?, :legal?, :financial?, to: :current_state


   def current_state
     (events.last.try(:state) || STATES.first).inquiry
   end

    def submitted?
        if current_state == 'complete'
            return true
        else
            return false
        end
   end


   def basics
     events.create! state: "basics" if goal?
   end

   def description
     events.create! state: "description" if basics?
   end

   def legal
     events.create! state: "legal" if description?
   end

   def financial
     events.create! state: "financial" if legal?
   end

   def complete
     events.create! state: "complete" if financial?
   end


end
