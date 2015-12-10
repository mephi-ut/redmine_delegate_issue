# encoding: UTF-8
require 'redmine'

require_dependency 'redmine_delegate_issue/hooks/view_issues_new_top'
require_dependency 'redmine_delegate_issue/hooks/view_layouts_base_html_head'
require_dependency 'redmine_delegate_issue/patches/app/controllers/issues_controller'
require_dependency 'redmine_delegate_issue/hooks/controller_issues_new_afterbefore_save'

Redmine::Plugin.register :redmine_delegate_issue do
	name 'Issue delegate button plugin'
	description 'A plugin to add a button to issue action menu. The button create a copy of the issues as a sub-issue.'
	url 'https://github.com/mephi-ut/redmine_delegate_issue'
	author 'Dmitry Yu Okunev'
	author_url 'https://github.com/xaionaro'
	version '0.0.2'

	permission :delegate_issue, {:issues => [:delegate]}
end

