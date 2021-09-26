class BulkDiscountsController < ApplicationController
  before_action :current_merchant

  def index
  end

  def show
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    discount = @merchant.bulk_discounts.create(discount_params)
    discount.save
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

private
  def discount_params
    params.require(:bulk_discount).permit(:bulk_name, :percentage_discount, :quantity_threshold)
  end

  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
