require 'klarna/checkout'
class Spree::CallbackController < ApplicationController

  protect_from_forgery except: [:push_uri]

  def push_uri
    # get the id
    checkout_id = params[:klarna_order]
    order_id    = params[:order_id]

    # call klarna API
    client = Klarna::Checkout::Client.new({
      shared_secret: Spree::Gateway::KlarnaCheckout.first.preferred_shared_secret,
      environment: :test # or :production
    })    


    remote_order = client.read_order(checkout_id)

    if remote_order.status == "checkout_complete"      

      # load spree order
      order = Spree::Order.find_by_number(order_id) 
      # order.payment.complete!
      # 

      remote_order.status = "created"
      remote_order.merchant_reference = { 'orderid1' => order.number }
      # update order (remote)
      client.update_order(remote_order)
    end    

  end

end