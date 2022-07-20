class Contact < ApplicationRecord
    validates :name, presence: true
    validates :phone_number, presence: true, length: { minimum: 10 }
end
