class ProductPolicy < ApplicationPolicy
    class Scope < Scope
        def resolve
            if scope.respond_to? :all
                scope.send(:all)
            else
                scope
            end
        end
    end
    
    def index?
        true
    end

    def create?
        is_admin?
    end

    def update?
        is_admin?
    end

    def destroy?
        is_admin?
    end
end