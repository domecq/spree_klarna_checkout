Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post "/push" => "checkout#push"
  match "/confirmation" => "checkout#confirmation"
end
