$(function() {
	$('.reply_form_link').on('click', function(e) {
		form_div = $(this).parent().find("div.wrap_reply_form");
		form_div.show(200);
		textarea = form_div.find('textarea');
		val = textarea.val();
		textarea.val("");
		textarea.focus();
		textarea.val(val);
	});

	$('.close_reply_form').on('click', function(e) {
		e.preventDefault();
		$(this).closest('div.wrap_reply_form').hide(200)
	})
});