class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.timestamps
    end
    add_reference :messages, :user, index: true
  end
end
