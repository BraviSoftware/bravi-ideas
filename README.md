Bravi Ideas
===========

[![Build Status](https://travis-ci.org/Bravi/bravi-ideas.png?branch=master)](https://travis-ci.org/Bravi/bravi-ideas)
[![Coverage Status](https://coveralls.io/repos/Bravi/bravi-ideas/badge.png?branch=master)](https://coveralls.io/r/Bravi/bravi-ideas?branch=master)
[![Code Climate](https://codeclimate.com/github/Bravi/bravi-ideas.png)](https://codeclimate.com/github/Bravi/bravi-ideas)

This amazing application was conceived to share ideas and proposals.
You are able to share your idea and people can vote for that.

You can help us to develop - the application was written in Ruby, using the Rails framework.

## Pre-Configuration
Add these configurations below into your .bashrc or .zshrc file and reload the shell after that:
```bash
export FACEBOOK_APP_ID="insert_the_facebook_app_id_here"
export FACEBOOK_SECRET="insert_the_secrete_key_here"
export BRAVI_EMAIL_USER="insert_the_gmail_user_here"
export BRAVI_EMAIL_PASSWORD="insert_the_gmail_password_here"
export NOTIFICATION_SOCKET_URL="http://localhost:8080/"
```

## Heroku commands

### Connect to rails console

```bash
heroku run rails console
```