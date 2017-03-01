module Concerns::String::SqlFilters
    #returns true if input string does not follow pattern of: Modelname or Modelname.find/where/order/limit
    #note: the where query is currently limited to only single hash conditions
    def destructive_transaction? (value = self)
        # destructive_methods = ['destroy', 'delete', 'update', 'create', 'save']
        # destructive_methods.any? { |method| value.include? method }

      value !~ /(?:\A[a-z]+)(?:(\.)?(?(1)(?:(?:limit|order|where)\(\w*:?\s?:?'?[\w\s-]*'?\))))*$/i
    end
end