Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post "/push" => "checkout_controller#push"
  post "/confirmation" => "checkout_controller#confirmation"
end
