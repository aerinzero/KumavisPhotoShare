class AddIsCheekyToImages < ActiveRecord::Migration
  def change
    add_column :images, :is_cheeky, :boolean, default: false
  end
end
