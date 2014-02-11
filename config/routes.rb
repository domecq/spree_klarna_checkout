Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post "/push" => "checkout_controllet#push"
  post "/confirmation_uri" => "checkout_controllet#confirmation"
end
