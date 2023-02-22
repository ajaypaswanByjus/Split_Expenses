class AddProfilePhotoToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :profile_photo, :binary
  end
end
