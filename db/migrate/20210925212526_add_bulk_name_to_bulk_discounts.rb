class AddBulkNameToBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_discounts, :bulk_name, :string
  end
end
