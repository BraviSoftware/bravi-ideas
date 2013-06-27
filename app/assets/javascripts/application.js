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
	$('.idea-like').click(like);
	$('.idea-unlike').click(unlike);

	$('.percentage-votes-bar').click(function(e) {
		var box = $(this).prev('.idea-content').find('.percentage-votes-values');

		if(box.is(':visible'))
			box.slideUp();
		else
			box.slideDown();

		e.preventDefault();
	});

	$('.idea .idea-content a h3').click(function (e) {
		var box = $('#wrapper-full-idea');

		if(box.is(':visible'))
			box.slideUp();
		else
			box.slideDown();

		e.preventDefault();
	});

	$('.btn-comments').click(function (e) {
		var box = $('.group-comments');

		if(box.is(':visible'))
			box.slideUp();
		else
			box.slideDown();

		e.preventDefault();
	});


	$('[data-toggle="tooltip"]').tooltip();
	$('[data-toggle="tooltip"]').hover(function() {
		//changeTooltipColorTo('#005580');
	})

	function changeTooltipColorTo(color) {
    $('.tooltip-inner').css('color', '#fff');
    $('.tooltip-inner').css('background-color', color)
    $('.tooltip.top .tooltip-arrow').css('border-top-color', color);
    $('.tooltip.right .tooltip-arrow').css('border-right-color', color);
    $('.tooltip.left .tooltip-arrow').css('border-left-color', color);
    $('.tooltip.bottom .tooltip-arrow').css('border-bottom-color', color);
}

	function like () {
		vote('like', getIdeaId(this), voteCallback, this);
	}

	function unlike () {
		vote('unlike', getIdeaId(this), voteCallback, this);
	}

	function getIdeaId (elment) {
		return $(elment).parents('#full-idea').first().data('idea');
	}

	function voteCallback (elment) {
		var labelTotal = $(elment).find('i');

		var voteTotal = parseInt(labelTotal.text());
		labelTotal.text(' ' + (voteTotal + 1));

		disableVoteButtons(elment);
	}

	function disableVoteButtons (elment) {
		var idea = $(elment).parents('#full-idea').first();

		$('.idea-like, .idea-unlike', idea)
		.addClass('disabled')
		.prop('disabled', true)
		.off('click');		
	}

	function vote (type, id, callback, elment) {
		$.ajax({
			type    : 'PUT',
			url     : 'http://localhost:3000/ideas/' + id + '/' + type + '.json'
		}).done(function(){
			callback(elment);
		});
	}
});