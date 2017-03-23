class GroupInvite < ActiveRecord::Base
    before_save :set_token
    validates :email, presence: true


    def set_token
        self.token ||= SecureRandom.uuid.gsub(/\-/, '').first(5).upcase
    end
end
