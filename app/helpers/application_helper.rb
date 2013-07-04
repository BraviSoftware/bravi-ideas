module ApplicationHelper
	def cp(path)
		' class=active' if current_page?(path)
	end

	def status_label(status, staus_name)
		content_tag(:span, staus_name, class: "label label-" + (status == 0 ? "success" : "important"))
	end
end
