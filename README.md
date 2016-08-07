# SeoReport

seo_report is a gem that provide a binary/executable called `seo-report`. With
this you can get a report of seo-relevant data for pretty much any URL.
It focuses on these aspects of seo-relevance:

* redirects, especially redirect-chains
* canonical URLs
* robots meta tags
* title and description
* social media data
  * twitter-cards (twitter)
  * open-graph (facebook)
* microdata (schema.org), *currently only in json output*
  
## planned functionality

* add support for structured data
  * read in rdfa-formatted structured data
  * (support json-ld? (embedded and linked?))

## installation

Add this line to your application's Gemfile:

```ruby
gem 'seo_report'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seo_report

## usage

* `seo-report URL`
  will provide you with a human-readable report on the command-line.
* `seo-report --json URL`
  will provide you with json output, that is parseable by other means (like for
  example [jq](https://stedolan.github.io/jq/)). Be aware that the json
  format is currently not set in stone. It is most likely to change until
  at least version *0.2.0* is reached.

## development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/0robustus1/seo_report. If you have any ideas regarding a
bigger feature change/addition i would recommend creating an issue before
setting down an implementing the code for a PR. This increases the chance of it
being merged, as it allows us to have a discussion beforehand.

## license

The gem is available as open source under the terms of the
[LGPL 3.0 License](http://choosealicense.com/licenses/lgpl-3.0/). A copy of the
license is part of this repository in the *LICENSE* file.

