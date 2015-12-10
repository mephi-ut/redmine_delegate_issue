# encoding: UTF-8

module DelegateIssue
	module IssuesControllerPatch
		def self.included(base)
			base.extend(ClassMethods)
			base.send(:include, InstanceMethods)

			base.class_eval do
				before_filter :find_project, :only => [:new, :create, :update_form, :delegate]
				before_filter :check_for_default_issue_status, :only => [:new, :create, :delegate]
				before_filter :authorize, :except => [:index, :delegate, :autocomplete_for_user]
				before_filter :build_new_issue_from_params, :only => [:new, :create, :update_form, :delegate]
				#before_filter :authorize, :except => [:delegate]
				#before_filter :find_project, :only => [:delegate]
				unloadable

				def delegate
					respond_to do |format|
						format.html { render :action => 'delegate', :layout => !request.xhr? }
					end
				end
			end
		end

		module ClassMethods
		end

		module InstanceMethods
		end
	end
end
IssuesController.send(:include, DelegateIssue::IssuesControllerPatch)

