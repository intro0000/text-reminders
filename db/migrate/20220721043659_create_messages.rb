class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :from_contact, foreign_key: {to_table: :contacts}, index: true
      t.references :to_contact, foreign_key: {to_table: :contacts}, index: true
      t.string :status
      t.string :twilio_id

      t.timestamps
    end
  end
end
