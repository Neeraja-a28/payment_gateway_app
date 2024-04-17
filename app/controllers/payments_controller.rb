class PaymentsController < ApplicationController
  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      notify_third_party_api(@payment)
      render json: @payment, status: :created
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  def update
    @payment = Payment.find(params[:id])

    if @payment.update(payment_params)
      notify_third_party_api(@payment)
      render json: @payment, status: :ok
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:name, :price)
  end

  def notify_third_party_api(payment)
    Stripe::Charge.create(
    amount: payment.price * 100, 
    currency: 'usd',
    description: 'Payment Description',
    source: 'tok_visa'
  end
end
