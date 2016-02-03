# Hooks to attach to the Redmine Issues.

class DelegateIssuePluginListener < Redmine::Hook::Listener
	def controller_issues_new_before_save(context = {})
		return unless context[:params]["delegate"] == "true"
		context[:issue].project    = Project.where(:identifier => User.find(context[:params][:issue][:assigned_to_id]).login).first
		#context[:issue].parent_id = context[:params]["copy_from"]
		context[:issue]['subject'] = "(#{l(:descr_delegated)}) #{context[:issue]['subject']}"
		#abort(context[:params].to_yaml)
		@delegate_from = Issue.find_by_id(context[:params]["delegate_from"]);
		context[:issue].attachments = @delegate_from.attachments.map do |attachement|
			attachement.copy(:container => context[:issue])
		end
	end
	def controller_issues_new_after_save(context = {})
		return unless context[:params]["delegate"] == "true"
		add_author(context[:issue])
		@delegated_from = Issue.find_by_id(context[:params]["delegate_from"]);
		relation = IssueRelation.new(:issue_from => @delegated_from, :issue_to => context[:issue], :relation_type => IssueRelation::TYPE_DELEGATED_TO)
		unless relation.save
			#abort("Could not create relation while delegating ##{@delegated_from.to_yaml} to ##{context[:issue].to_yaml} due to validation errors: #{relation.errors.full_messages.join(', ')}")
		end
	end

	private

	# copied from https://github.com/mephi-ut/redmine_auto_role
	def add_author(issue)
		project = Project.find_by_id(issue['project_id'])
		if project.module_enabled?("auto_roles")
			Rails.logger.warn("Project ID: #{issue['project_id']}")
			author_role_id = project.custom_field_value(Setting.plugin_redmine_auto_role['author_autorole_custom_field_id'])
			unless author_role_id.nil? || author_role_id.empty? || author_role_id == '1'
				Rails.logger.warn("Adding. Role ID: #{author_role_id}")
				member         = Member.new
				member.user    = issue.author
				member.project = project
				member.roles  += [Role.find(author_role_id)]
				member.save
			end
		end
	end
end
