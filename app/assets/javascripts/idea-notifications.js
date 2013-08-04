BraviIdeas.IdeaNotification = function (viewModel, commentModelFunction) {
  var notify_new_comment = function (data) {
        if(connection.socket.connected)
          connection.emit('idea-new-comment', data);
      },
      notify_remove_comment = function(data) {
        if(connection.socket.connected)
          connection.emit('idea-comment-removed', data);
      },
      notify_idea_rate = function(data) {
        if(connection.socket.connected)
          connection.emit('idea-rate', data);
      },
      notify_new_idea = function(data) {
        if(connection.socket.connected)
          connection.emit('new-idea');
      },
      notify_remove_idea = function(data) {
        if(connection.socket.connected)
          connection.emit('idea-removed');
      }
      connection = arguments[2] || getSocketIoConnection();

  function getSocketIoConnection() {
    //return io.connect('http://localhost:8080/');
    return io.connect('http://bravi-ideas-notify.herokuapp.com:80/');
  };

  connection.on('idea-new-comment', function (data) {   
    if (viewModel.selected() && viewModel.selected().id === data.ideaId) {
      var model = new BraviIdeas.CommentModel(data.commentModel);
      viewModel.comments.push(model);
    }

    $(viewModel.ideas()).each(function(index, item) {
      if (item.id === data.ideaId) {
        item.upCommentsAmount();
      }
    });
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

  connection.on('idea-rate', function (data) {
    $.each(viewModel.ideas(), function (index, item) {
        if (item.id === data.ideaId) {
          item.vote(data.voteType);
          return;
        }
    });
  });

  connection.on('new-idea', function (data) {
    //TODO: update viewmodel with new idea
  });

  connection.on('idea-removed', function (data) {
    //TODO: remove idea from view model, treat if it is selected
  });

  return {
    notify_new_comment: notify_new_comment,
    notify_remove_comment: notify_remove_comment,
    notify_idea_rate: notify_idea_rate
  };

};