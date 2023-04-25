Rails.application.routes.draw do
  namespace :riverbed do
    patch ":api_key/links/:link_id", to: "links#update", as: "link"
  end
end
