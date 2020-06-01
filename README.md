![Shield](https://raw.githubusercontent.com/mtgrosser/rack-shield/master/doc/shield.svg)

# Rack::Shield

Simple frontend to block and unblock evil requests with `Rack::Attack`

## Installation

In your Gemfile:

```ruby
gem 'rack-attack-shield'
```

## Usage

Check whether request is evil:

```ruby
Rack::Shield.evil?(request)
```

With `Rack::Attack::Fail2Ban`:

```ruby
# After one blocked request in 10 minutes, block all requests from that IP for 5 minutes.
Rack::Attack.blocklist('fail2ban pentesters') do |req|
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 1, findtime: 10.minutes, bantime: 5.minutes) do
    Rack::Shield.evil?(req)
  end
end
```

## Configuration

Adding to path matchers:

```ruby
# Regexp will be matched
Rack::Shield.evil_paths << /\.sql\z/

# String will be checked for inclusion
Rack::Shield.evil_paths << '/wp-admin'
```
Defaults are defined in `Rack::Shield::DEFAULT_EVIL_PATHS`.

## Blocked response

By default, the blocked response is generated automatically:

```ruby
# default
Rack::Shield.response = Rack::Shield::Response
```

It can be set to any `call`able object which conforms to the `Rack` interface:

```ruby
Rack::Shield.response = ->(env) { [403, { 'Content-Type' => 'text/html' }, ["Blocked!\n"]]
```

In Rails apps, the blocked response will be generated from `app/views/layouts/shield.html`.
