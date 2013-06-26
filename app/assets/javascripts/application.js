// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(function (argument) {
	$('.idea > .idea-like').click(like);
	$('.idea > .idea-unlike').click(unlike);

	$('.percentage-votes-bar').click(function(e) {
		var box = $(this).prev('.idea-content').find('.percentage-votes-values');

		if(box.is(':visible'))
			box.slideUp();
		else
			box.slideDown();

		e.preventDefault();
	});

	$('[data-toggle="tooltip"]').tooltip();

	function like () {
		if(!isDisabled(this)) vote('like', getIdeaId(this), voteCallback(this));
	}

	function unlike () {
		if(!isDisabled(this)) vote('unlike', getIdeaId(this), voteCallback(this));
	}

	function getIdeaId (elment) {
		return $(elment).parent('.idea').data('idea');
	}

	function voteCallback (elment) {
		var labelTotal = $(elment).find('i');

		var voteTotal = parseInt(labelTotal.text());
		labelTotal.text(' ' + (voteTotal + 1));

		disableVoteButtons(elment);
	}

	function disableVoteButtons (elment) {
		var idea = $(elment).parent('.idea');

		$('.idea-like, .idea-unlike', idea)
		.addClass('disabled')
		.attr('disabled', 'disabled');		
	}

	function isDisabled (element) {
		return $(element).attr('disabled');
	}

	function vote (type, id, callback) {
		$.ajax({
			type    : 'PUT',
			url     : 'http://localhost:3000/ideas/' + id + '/' + type + '.json',
			success : callback
		});
	}
});