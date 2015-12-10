Rails.application.routes.draw do
	resources :projects do
		get 'issues/:copy_from/delegate', :to => 'issues#delegate', :as_subtask => 1, :as => 'delegate_issue'
	end
end
