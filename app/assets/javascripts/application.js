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
//= require toastr
//= require_self
//= require_tree .

// Create js namespace
var BraviIdeas = BraviIdeas || {};
BraviIdeas.app = (function(){
	var currentUserId = function (){
		return parseInt($('#user').data('id'), 10);
	},

	isUserAuthenticated = function(){
		return currentUserId() && currentUserId() > 0;
	};

	var vm = {
		currentUserId: currentUserId,
		isUserAuthenticated: isUserAuthenticated
	};

	return vm;
});