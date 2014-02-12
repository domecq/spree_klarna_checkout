Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  post "/push_uri" => "checkout#push_uri"
  get "/confirmation" => "checkout#confirmation"
end
