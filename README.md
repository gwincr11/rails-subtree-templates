# Setup

- Make a copy of `.env.example` and name it `.env`, then add your own GitHub login and authentication token to it.
- Install Ruby 4.2.1
- `bundle install`
- `bundle exec rake create_update_domains # pull in git content`
- `bundle exec rails s`

Configure your local domains. The default setup uses http://domain1.com:3000/ and http://domain2.com:3000/ these will need to be added to your local host files.

- edit /etc/hosts
- add the line `127.0.0.1	localhost domain1.com domain2.com localhubber.com`
- Navigate to domain1.com:3000, domain2.com:3000, and localhubber.com:3000/docs/tools/advanced-search to ensure they work.
