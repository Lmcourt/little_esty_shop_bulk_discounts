class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items

  validates :bulk_name, presence: true
  validates :percentage_discount, numericality: {only_integer: true}, presence: true
  validates :quantity_threshold, numericality: {only_integer: true}, presence: true
end
