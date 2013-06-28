var viewModelIdea = (function(){
	var ideas = ko.observableArray([]),

	like = function () {
		vote('like', getIdeaId(this), voteCallback, this);
	},

	unlike = function () {
		vote('unlike', getIdeaId(this), voteCallback, this);
	},

	getIdeaId = function (elment) {
		return $(elment).parents('#full-idea').first().data('idea');
	},

	voteCallback = function (elment) {
		var labelTotal = $(elment).find('i');

		var voteTotal = parseInt(labelTotal.text());
		labelTotal.text(' ' + (voteTotal + 1));

		disableVoteButtons(elment);
	},

	disableVoteButtons = function (elment) {
		var idea = $(elment).parents('#full-idea').first();

		$('.idea-like, .idea-unlike', idea)
		.addClass('disabled')
		.prop('disabled', true)
		.off('click');		
	},

	getAll = function(){
		$.ajax({
			type    : 'GET',
			url     : '/home/index.json'
		}).done(function(data){
			ideas(data);
		});
	},

	vote = function (type, id, callback, elment) {
		$.ajax({
			type    : 'PUT',
			url     : '/ideas/' + id + '/' + type + '.json'
		}).done(function(){
			callback(elment);
		});
	},

	getTotal = function(item){
		return item.positive + item.negative
	},

	percentPositive = function(item){

		if (getTotal(item) === 0){
			return 50;
		}

		return (item.positive * 100 ) / getTotal(item);
	},

	percentNegative = function(item){

		if (getTotal(item) === 0){
			return 50;
		}

		return (item.negative * 100 ) / getTotal(item);
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
		percentPositive: percentPositive,
		percentNegative: percentNegative,
		ideasGroupRows: ideasGroupRows,
		selected: selected,
		selectIdea: selectIdea,
	};

	init();

	return vm;
});

// Bind to view
ko.applyBindings(new viewModelIdea());