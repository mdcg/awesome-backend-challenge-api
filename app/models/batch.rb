class Batch < ApplicationRecord
    validates :reference, presence: true 
    validates :purchase_channel, presence: true

    belongs_to :user
    has_many :orders, dependent: :destroy
end
