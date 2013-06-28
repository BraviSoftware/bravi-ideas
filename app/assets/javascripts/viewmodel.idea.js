var viewModelIdea = (function(){
	var ideas = ko.observableArray([]),

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
			url     : '/home/index.json'
		}).done(function(data){
			mapToModel(data);
			ideas(data);
		});

		function mapToModel(items){
			for(var i = 0; i < items.length; i++){
				// override dto for a proper model
				items[i] = new IdeaModel(items[i]);				
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


	selected = ko.observable(),
	selectIdea = function(item){
		var newItem = !selected() || (item.id !== selected().id);

		selected(item);

		var box = $('#wrapper-full-idea');

		if(box.is(':visible') && !newItem)
			box.slideUp();
		else
			box.slideDown();
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
		ideas: ideas,
		like: like,
		unlike: unlike,
		getIdeaId: getIdeaId,
		voteCallback: voteCallback,
		disableVoteButtons: disableVoteButtons,
		vote : vote,
		ideasGroupRows: ideasGroupRows,
		selected: selected,
		selectIdea: selectIdea,
	};

	init();

	return vm;
});

// Bind to view
ko.applyBindings(new viewModelIdea());