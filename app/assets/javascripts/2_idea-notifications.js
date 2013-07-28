var IdeaNotification = function (viewModel, commentModelFunction) {
	var notify_new_comment = function (ideaId, commentId) {
			connection.emit('idea-new-comment', ideaId);
		},
		notify_remove_comment = function(ideaId, commentId) {
			connection.emit('idea-comment-removed', ideaId);
		},
		notify_rate_like = function(ideaId) {
			connection.emit('idea-rate-like');
		},
		notify_rate_dislike = function(ideaId) {
			connection.emit('idea-rate-dislike');
		},		
		connection = arguments[2] ? arguments[2] : getSocketIoConnection();

	function getSocketIoConnection() {
		return io.connect('http://localhost:8080/');
	};

	connection.on('idea-new-comment', function (data) {		
		if (viewModel.selected() && viewModel.selected().id === data.ideaId) {
			viewModel.comments.push(commentModelFunction(data.commentModel));
		}
		else {
			$(viewModel.ideas()).each(function(index, item) {
				if (item.id === data.ideaId) {
					item.upCommentsAmount();
				}
			});
		}
	});
	connection.on('idea-comment-removed', function (data) {
		if (viewModel.selected() && viewModel.selected().id === data.ideaId) {
			$.each(viewModel.comments(), function (index, item) {
				if (item.id === data.commentModel.id) {
					viewModel.comments.splice(index, 1);
					viewModel.selected().downCommentsAmount();
					return;
				}
			});
		}
		else {
			$(viewModel.ideas()).each(function(index, item) {
				if (item.id === data.ideaId) {
					item.downCommentsAmount();
				}
			});
		}
	});

	return {
		notify_new_comment: notify_new_comment,
		notify_remove_comment: notify_remove_comment
	};

};	