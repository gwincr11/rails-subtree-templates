# Setup

- Install Ruby 4.2.1
- `bundle install`
- `bundle exec rake create_update_domains # pull in git content`
- `bundle exec rails s`

Configure your local domains. The default setup uses http://domain1.com:3000/ and http://domain2.com:3000/ these will need to be added to your local host files.

- edit /etc/hosts
- add the line `127.0.0.1	localhost www.domain1.com domain1.com domain2.com localhubber.com`
- Navigate to domain1.com:3000 and domain2.com:3000 to ensure they work.
