class Order < ApplicationRecord
    include Helpers::ResourceStateHelper
    include Helpers::ResourceRecordHelper

    belongs_to :user
    has_many :line_items, dependent: :destroy, inverse_of: :order
    has_many :products, through: :line_items, source: :lineable, source_type: 'Product'
    has_many :promotions, through: :line_items, source: :lineable, source_type: 'Promotion'
    
    accepts_nested_attributes_for :products, :promotions, reject_if: :all_blank

    resourcify

    include AASM
    STATES = [:pending, :activated, :completed, :canceled]
    aasm :column => 'resource_state' do
        STATES.each do |status|
            state(status, initial: STATES[0] == status)
        end

        before_all_events :set_state_user

        event :complete do
            transitions from: [:pending], to: :completed, success: :set_completion_date!
        end

        event :cancel do
            transitions from: STATES, to: :canceled
        end
    end

    # This is temporary, waiting to think of a better solution. Do not test.
    def promotions_attributes=(promotions_attributes)
        promotions_attributes.each do |key, promotion_attributes|
            line_items.build(lineable_type: 'Promotion', lineable_id: promotions_attributes[key][:id], item_cost: promotions_attributes[key][:cost])
        end
    end

    def set_completion_date!(date = DateTime.now)
       self.update!(completion_date: date)
    end

end
