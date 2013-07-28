BraviIdeas.CommentModel = (function (dto) {
	var self = this;

	self.id = dto.id;
	self.description = dto.description; 
	self.user_id = dto.user_id;
  	self.user_name = dto.user_name;
	self.user_image = dto.user_image;

	self.belongsToCurrentUser = function() {
		return self.user_id === BraviIdeas.app().currentUserId();
	};

	return self;
});