class AddBodyToMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :body, :string
  end
end
