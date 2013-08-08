BraviIdeas.IdeaNotification = function (options) {
  var viewModel = options.viewModel, 
      commentModelFunction = options.commentModelFunction, 
      toastr = options.toastr;

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
      connection = arguments[1] || getSocketIoConnection();

  function getSocketIoConnection() {
    return io.connect('http://localhost:8080/');
    //return io.connect('http://bravi-ideas-notify.herokuapp.com:80/');
  };

  connection.on('idea-new-comment', function (data) {   
    if (viewModel.selected() && viewModel.selected().id === data.ideaId) {
      var model = new BraviIdeas.CommentModel(data.commentModel);
      viewModel.comments.push(model);
      toastr.info("New comment added by " + data.commentModel.user_name);
    }
    else {
      $(viewModel.ideas()).each(function(index, item) {
      if (item.id === data.ideaId) {
          item.upCommentsAmount();

          toastr.info("New comment added by " + data.commentModel.user_name + " in idea " + data.ideaTitle);
          return false;
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

          toastr.info("Comment \'" 
            + data.commentModel.description.length > 40 ? 
                data.commentModel.description.substring(0, 40) 
                : data.commentModel.description 
            + "\' removed by " + data.commentModel.user_name);

          return false;
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
        toastr.info("Idea " + data.ideaTitle + " rated by " + data.userName);
        return false;
      }
    });
  });

  connection.on('new-idea', function (data) {
    viewModel.loadSingleIdea(data.ideaId);
    toastr.info("New idea created by " + data.userName);
  });

  connection.on('idea-removed', function (data) {
    $.each(viewModel.ideas(), function (index, item) {
      if (item.id === data.ideaId) {
        viewModel.ideas.splice(index, 1);
        viewModel.amountIdeas(viewModel.ideas().length);
        toastr.info("Idea " + data.ideaTitle + " removed by " + data.userName);
        return false;
      }
    });
  });

  return {
    notify_new_comment: notify_new_comment,
    notify_remove_comment: notify_remove_comment,
    notify_idea_rate: notify_idea_rate
  };

};