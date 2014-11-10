module PreserveScroll
	class Hooks < Redmine::Hook::ViewListener
		render_on :view_issues_new_top, :partial => 'issues/delegate_routines'
	end
end
