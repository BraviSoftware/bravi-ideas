var BraviIdeas = BraviIdeas || {};
BraviIdeas.ViewModelIdea = (function(){
	var ideas = ko.observableArray([]),
	comments = ko.observableArray([]),
	comment = ko.observable(),

	isUserAuthenticated = function(){
		return $('#user').data('id');
	},

	canVote = ko.computed(function(){
		return isUserAuthenticated();
	}),

	like = function () {
		vote('like', voteCallback, this);
	},

	unlike = function () {
		vote('unlike', voteCallback, this);
	},

	getIdeaId = function (elment) {
		return selected() && selected().id;
	},

	voteCallback = function (voteType, idea) {
		idea.vote(voteType);
		disableVoteButtons();
	},

	disableVoteButtons = function () {
		$('.idea-like, .idea-unlike', '#full-idea')
		.addClass('disabled')
		.prop('disabled', true)
		.off('click');
	},

	getAll = function(){
		$.ajax({
			type    : 'GET',
			url     : '/home/ideas.json'
		}).done(function(data){
			mapToModel(data);
			ideas(data);
		});

		function mapToModel(items){
			for(var i = 0; i < items.length; i++){
				// override dto for a proper model
				items[i] = new BraviIdeas.IdeaModel(items[i]);				
			};
		}
	},

	getComments = function(idea, callback){
		$.ajax({
			type    : 'GET',
			url     : '/home/comments/' + idea + '.json'
		}).done(function(data){
			mapToModel(data);
			comments(data);
			callback();
		});

		function mapToModel(items){
			for(var i = 0; i < items.length; i++){
				// override dto for a proper model
				items[i] = new BraviIdeas.CommentModel(items[i]);				
			};
		}
	},

	vote = function (type, callback, idea) {
		$.ajax({
			type    : 'PUT',
			url     : '/ideas/' + idea.id + '/' + type + '.json'
		}).done(function(){
			callback(type, idea);
		});
	},

	saveNewComment = function (description, idea) {
		return $.ajax({
			type    : 'POST',
			data 	: { 'description': description, 'idea_id':  idea },
			url     : '/home/add_comment.json',
			dataType : 'json'
		});
	},

	addComment = function(){
		if(!comment()){
			toastr.warning('<strong>Really?!</strong><br>Commenting without a text?! Don\'t do that.');
			return;
		}

		$.when(saveNewComment(comment(), selected().id))
		.done(function(data){
			var model = new BraviIdeas.CommentModel(data);
			comments.push(model);
			comment('');
			toastr.success('Successfully saved.');
		});
	},

	deleteComment = function (comment) {
		return $.ajax({
			type    : 'DELETE',
			url     : '/home/remove_comment/' + comment.id + '.json'
		});
	},

	removeComment = function(){
		var commentToDelete = this;
		$.when(deleteComment(commentToDelete)).done(completed);
		
		function completed(){
			for (var i = 0; i < comments().length; i++) {
				if(comments()[i].id === commentToDelete.id){
					comments.splice(i, 1);
					break;
				}
			};

			toastr.success('Successfully removed.');
		}
	},

	selected = ko.observable(),
	selectIdea = function(item){
		var newItem = !selected() || (item.id !== selected().id);

		selected(item);

		var box = $('#wrapper-full-idea');

		if(box.is(':visible') && !newItem){
			box.fadeOut();
		}
		else{
			getComments(selected().id, completed);

			function completed(){
				positionFullIdeaBox();
				box.fadeIn();

				$(window).on('resize', positionFullIdeaBox);

				function positionFullIdeaBox(){
					var boxPreview = $('.idea[data-idea="' + selected().id + '"]');
					var box = $('#wrapper-full-idea');
					var position = boxPreview.position();

					$('#arrow').css('margin-left', (position.left + 20) + 'px');

					box.css('top', (boxPreview.height() + position.top + 10) + 'px');
				}
			};
		}
	},


	ideasGroupRows = ko.computed(function () {

		var items =  ideas(),
		result = [];
		for (var i = 0; i < items.length; i += 3) {
			var row = [];
			for (var j = 0; j < 3; ++j) {
				if (items[i + j]) {
					row.push(items[i + j]);
				}
			}
			result.push(row);
		}
		return result;
	});


	init = function(){
		getAll();
	};

	var vm = {
		canVote: canVote,
		ideas: ideas,
		comments: comments,
		comment: comment,
		like: like,
		unlike: unlike,
		getIdeaId: getIdeaId,
		voteCallback: voteCallback,
		disableVoteButtons: disableVoteButtons,
		ideasGroupRows: ideasGroupRows,
		addComment: addComment,
		removeComment: removeComment,
		selected: selected,
		selectIdea: selectIdea
	};

	init();

	return vm;
});

// Bind to view
ko.applyBindings(new BraviIdeas.ViewModelIdea());