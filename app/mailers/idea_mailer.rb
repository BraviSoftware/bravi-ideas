class IdeaMailer < ActionMailer::Base
  default from: ENV['BRAVI_EMAIL_USER']

  def new_comment(comment)
    @comment = comment
    mail(to: @comment.idea.user.email, subject: "New Comment - Bravi Ideas")
  end
end
