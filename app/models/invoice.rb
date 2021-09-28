class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def merchant_total_revenue(merchant)
    invoice_items.joins(:item)
                 .where('items.merchant_id = ?', merchant)
                 .sum('invoice_items.unit_price * quantity')
  end

  def discounted_revenue
    invoice_items.sum do |ii|
      if ii.highest_discount
        ii.discounted_price
      else
        ii.revenue
      end
    end
  end

  # def discounted_revenue(merchant_id)
  #   invoice_items.sum do |ii|
  #     if ii.highest_discount && ii.merchant.id == merchant_id
  #       ii.discounted_price
  #     else
  #       ii.revenue
  #     end
  #   end
  # end

  def merchant_discounted_revenue(merchant)
    invoice_items.joins(:items)
                .where('items.merchant_id = ?', merchant)
                .sum(merchant_total_revenue(merchant) - invoice_items.discounted_price)
  end
end
