class Contact < ApplicationRecord
    has_many :sent_messages, class_name: "Message", foreign_key: "from_contact_id"
    has_many :received_messages, class_name: "Message", foreign_key: "to_contact_id"

    validates :name, presence: true
    validates :phone_number, presence: true, length: { minimum: 10 }
end
