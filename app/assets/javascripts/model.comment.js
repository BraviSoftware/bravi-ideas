var BraviIdeas = BraviIdeas || {};
BraviIdeas.CommentModel = (function (dto) {
	var self = this;

	self.id = dto.id;
	self.description = dto.description; 
	self.user_id = dto.user_id;
	self.user_image = dto.user_image;

	self.belongsToCurrentUser = function() {
		return self.user_id === parseInt($('#user').data('id'),10);
	};

	return self;
});