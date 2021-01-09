# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
match '/time_entries/:id/show', :to => 'timelog#show',  :as => :show_time_entries,  :via => :get, :id => /\d+/
