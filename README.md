# ActiveModelAuthorization

Simple, elegant and fully customizable authorizations for models in the language we all love; Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model_authorization', github: 'keram/active_model_authorization', branch: '0-1-stable'
```

And then execute:

    $ bundle

## Usage

Include into Model you want to provide authorizations for lines:

```ruby
include ActiveModelAuthorization::Concern

def self.authorization_requester_role(requester)
  # Here comes application or model specific role logic
  # for example ``requester.role``
  # returns CamelCaseString
end

def authorization_requester_role(requester)
  # Instance specific role logic or forward to class
  self.class.authorization_requester_role(requester)
end

```

Create specific role authorization class, which inherits
from ActiveModelAuthorization::Authorization class, stored in:
``authorizations/model_specific_namespace/model_name/`` directory.

Example:

```ruby
# path: app/models/authorizations/application_record/admin_authorization.rb
#
# frozen_string_literal: true
module ActiveModelAuthorization
  module Authorizations
    module ApplicationRecord
      class AdminAuthorization < Authorization
        # Allow by default all actions for admins
        DEFAULT_STATUS = true
      end
    end
  end
end
```
```ruby
# Path: app/models/authorizations/application_record/user_authorization.rb
#
# frozen_string_literal: true
module ActiveModelAuthorization
  module Authorizations
    module ApplicationRecord
      class UserAuthorization < Authorization
        # User can update only himself
        def can_update?
          requester == sender
        end
      end
    end
  end
end
```

In the controller action method, where you want the authorization performed, add:

``sender.authorize!(requester, message_name)`` where:

``sender`` is object that should receive message,
``requester`` is instance of object which wants the message to be send (typically this will be value of current_user).
``message_name`` is message to be send to sender as a String or Symbol


Handle the ActiveModelAuthorization::AccessDenied exception either by using
``rescue`` clause or globally using ``rescue_from``
http://api.rubyonrails.org/classes/ActiveSupport/Rescuable/ClassMethods.html#method-i-rescue_from

Example of controller:

```ruby
# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  rescue_from ActiveModelAuthorization::AccessDenied, with: :access_denied

  # GET /users
  def index
    @users = User.all
    @users.authorize!(current_user, :list)

    render json: @users, each_serializer: IndexUserSerializer
  end

  # GET /users/1
  def show
    @user.authorize!(current_user, :show)
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.authorize!(current_user, :create)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    @user.authorize!(current_user, :update)
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.authorize!(current_user, :destroy)
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user)
          .permit(:username, :email, :password)
  end

  def access_denied(exception)
    render json: {
      errors: [
        {
          status: 403,
          title: 'Access denied',
          detail: exception.message
        }
      ]
    }, status: :forbidden
  end
end
```

**Profit!**

For more specific and custom usage visit our wiki
https://github.com/keram/active_model_authorization/wiki page.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/keram/active_model_authorization.

