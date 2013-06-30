var IdeaModel = (function (dto) {
	var self = this;

	self.id = dto.id;
	self.created_date = dto.created_date;
	self.description = dto.description; 
	self.title = dto.title;
	self.positive = ko.observable(dto.positive);
	self.negative = ko.observable(dto.negative);

	self.getTotal = function(){
		return self.positive() + self.negative();
	};

	self.percentPositive = ko.computed(function(){

		if (self.getTotal() === 0){
			return 50;
		}

		return ((self.positive() * 100 ) / self.getTotal()).toFixed(2);
	});

	self.percentNegative = ko.computed(function(){

		if (self.getTotal() === 0){
			return 50;
		}

		return ((self.negative() * 100 ) / self.getTotal()).toFixed(2);
	});

	self.vote = function(voteType){
		if(voteType ===  'like')
			self.positive(self.positive() + 1);
		else
			self.negative(self.negative() + 1);
	};

	return self;
});