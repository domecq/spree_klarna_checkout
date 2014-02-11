#/app/models/spree/gateway/pay_gate.rb
class Spree::Gateway::KlarnaCheckout < Spree::Gateway
  preference :login, :string
  preference :password, :string

  preference :id, :string
  preference :shared_secret, :string

  def provider_class
    ActiveMerchant::Billing::KlarnaCheckout
  end
end
