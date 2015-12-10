# Hooks to attach to the Redmine Issues.

class DelegateIssuePluginListener < Redmine::Hook::Listener
	def controller_issues_new_before_save(context = {})
		return unless context[:params]["delegate"] == "true"
		context[:issue].project    = Project.where(:identifier => context[:issue].assigned_to.login).first
		#context[:issue].parent_id = context[:params]["copy_from"]
		context[:issue]['subject'] = "(#{l(:descr_delegated)}) #{context[:issue]['subject']}"
		#abort(context[:params].to_yaml)
	end
	def controller_issues_new_after_save(context = {})
		return unless context[:params]["delegate"] == "true"
		@delegated_from = Issue.find_by_id(context[:params]["delegate_from"]);
		relation = IssueRelation.new(:issue_from => @delegated_from, :issue_to => context[:issue], :relation_type => IssueRelation::TYPE_DELEGATED_TO)
		unless relation.save
			#abort("Could not create relation while delegating ##{@delegated_from.to_yaml} to ##{context[:issue].to_yaml} due to validation errors: #{relation.errors.full_messages.join(', ')}")
		end
	end

	private
end
