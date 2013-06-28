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

	$(document).on('click', '.percentage-votes-bar', function(e) {
		var box = $(this).prev('.idea-content').find('.percentage-votes-values');

		if(box.is(':visible'))
			box.slideUp();
		else
			box.slideDown();

		e.preventDefault();
	});


	$(document).on('click', '.btn-comments', function(e) {
		var box = $('.group-comments');

		if(box.is(':visible'))
			box.slideUp();
		else
			box.slideDown();

		e.preventDefault();
	});		
});