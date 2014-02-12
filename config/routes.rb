Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post "/push" => "checkout#push"
  get "/confirmation" => "checkout#confirmation"
end
