ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'bravi-ideas.herokuapp.com',
  user_name:            ENV['BRAVI_EMAIL_USER'],
  password:             ENV['BRAVI_EMAIL_PASSWORD'],
  authentication:       'plain',
  enable_starttls_auto: true  
}

ActionMailer::Base.default_url_options[:host] = "bravi-ideas.herokuapp.com"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?