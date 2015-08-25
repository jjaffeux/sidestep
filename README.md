# bypass

Bypass allows you to launch a specific controller of your app on demand. If you are working on a controller which requires several manual actions to access each time you build your app, you can use Bypass to directly load this controller, and even set some args.

## Installation

Add this line to your application's Gemfile:

    gem 'bypass'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bypass

## Usage

You should now have access to a new rake task command :

    rake bypass[MyController]

You can also provide params to your controller :

    rake bypass[MyController] id=5

## Custom behavior

If you need to add custom initialization (Google analytics SDK...) in the delegate before showing the controller, you can create your own `app_delegate.erb` (note: it's ERB not RB) at the root of the app. See this repository for example.
