require 'klarna/checkout'

Spree::CheckoutController.class_eval do

  def push
    # # get the id
    # checkout_id = params[:klarna_order]
    # # call klarna API
    # client = Klarna::Checkout::Client.new({
    #   shared_secret: Spree::Gateway::KlarnaCheckout.first.preferred_shared_secret,
    #   environment: :test # or :production
    # })


  end
  def confirmation

    # call klarna API
    client = Klarna::Checkout::Client.new({
      shared_secret: Spree::Gateway::KlarnaCheckout.first.preferred_shared_secret,
      environment: :test # or :production
    })


  end

  private

  def before_payment
    if @order.checkout_steps.include? "delivery"
      packages = @order.shipments.map { |s| s.to_package }
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        @order.contents.remove(variant, quantity)
      end

      call_klarna_api   

    end
  end

  def call_klarna_api
    binding.pry

    # call klarna API
    client = Klarna::Checkout::Client.new({
      shared_secret: Spree::Gateway::KlarnaCheckout.first.preferred_shared_secret,
      environment: :test # or :production
    })

    # get item from spree
    items = []
    @current_order.line_items.each do |prod|
      items << {
          reference:  prod.variant.sku,
          name:       prod.variant.name,
          quantity:   prod.quantity.to_i,
          unit_price: to_klarna_i(prod.variant.price),
          tax_rate:   2500 #(@current_order.tax_total * 100).to_s
      }
    end

    # Initialize an order
    order = Klarna::Checkout::Order.new({
      purchase_country: 'NO',
      purchase_currency: 'NOK',
      locale: 'nb-no',
      cart: {
        items: items
      },
      merchant: {
        id: Spree::Gateway::KlarnaCheckout.first.preferred_id,
        terms_uri:        'http://spreetest.pixelwerk.no/terms',
        checkout_uri:     'http://spreetest.pixelwerk.no/checkout',
        confirmation_uri: 'http://spreetest.pixelwerk.no/confirmation_uri',
        push_uri:         'http://spreetest.pixelwerk.no/push'
      }
    })

    # Create the order with Klarna
    client.create_order(order)

    # Read an order from Klarna
    @remote_order = client.read_order(order.id)           
  end

  def to_klarna_i(number)
    ('%i' % (number.to_s.to_f.round(2)*100)).to_i
  end

end
