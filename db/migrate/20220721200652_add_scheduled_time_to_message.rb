class AddScheduledTimeToMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :scheduled_time, :datetime
  end
end
