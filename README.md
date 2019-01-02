# README

## Usage

fill every necessary environment variables in `config/application.yml.example`, and rename it to

```
mv config/application.yml.example config/application.yml
```

Make sure you're using Ruby 2.5.1.
then follow the usual Rails project installation steps:

```
gem install bundler # if you just install ruby 2.5.1
bundle install
rake db:create
rake db:migrate # in fact, schema is empty but if you skip this step, it might complain.
```

You can first run it on local site via command

```
rails s
```

and if you'd like to test webhook from Line - Yes, you might need to setup line developer account and turn on every needed settings - Which I believe you've done at step 0 `config/application.yml`, now you can start to test by using [ngrok](https://ngrok.com/), the tool is amazingly simple and helpful.

Now, have fun with your own rumor-checker :)


## License

The project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
