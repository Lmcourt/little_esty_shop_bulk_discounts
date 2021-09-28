class BulkDiscountsController < ApplicationController
  before_action :current_merchant

  def index
    @holidays = BulkDiscountFacade.holidays
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    discount = @merchant.bulk_discounts.create(discount_params)

    if discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = "Error. Please fill in all fields."
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update(discount_params)
    redirect_to(merchant_bulk_discount_path(@merchant, @bulk_discount))
  end

private
  def discount_params
    params.require(:bulk_discount).permit(:bulk_name, :percentage_discount, :quantity_threshold)
  end

  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
