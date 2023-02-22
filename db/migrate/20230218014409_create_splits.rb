class CreateSplits < ActiveRecord::Migration[7.0]
  def change
    create_table :splits do |t|
      t.float :amount
      t.integer :user_id
      t.integer :expense_id

      t.timestamps
    end
  end
end
