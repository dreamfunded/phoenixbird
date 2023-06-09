class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :company
    belongs_to :group

    has_ancestry

    def comment_owner
        if comment_belongs_to_company_owner?
            self.company.name + " Team"
        end
    end

    def comment_belongs_to_company_owner?
        self.user.company == self.company && self.company!= nil
    end

end
