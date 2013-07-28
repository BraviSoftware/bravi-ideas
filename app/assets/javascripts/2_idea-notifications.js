var IdeaNotification = function (viewModel) {
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
		connection = arguments[1] ? arguments[1] : getSocketIoConnection();

	function getSocketIoConnection() {
		return io.connect('http://localhost:8080/');
	};

	connection.on('idea-new-comment', function (ideaId, commentId) {
		$(viewModel.ideas()).each(function(index, item) {
			if (item.id === ideaId) {
				item.upCommentsAmount();
			}
		});
	});
	connection.on('idea-comment-removed', function (ideaId, commentId) {
		$(viewModel.ideas()).each(function(index, item) {
			if (item.id === ideaId) {
				item.downCommentsAmount();
			}
		});
	}); 

	return {
		notify_new_comment: notify_new_comment,
		notify_remove_comment: notify_remove_comment
	};

};	