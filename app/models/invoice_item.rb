class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def revenue
    quantity * unit_price
  end

  def highest_discount
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity)
                  .select('bulk_discounts.*')
                  .order(percentage_discount: :desc)
                  .first
  end

  def discounted_price
    revenue * (1 - highest_discount.percentage_discount.fdiv(100))
  end
end
