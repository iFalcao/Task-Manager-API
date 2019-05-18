# Task Manager API

This is a Ruby on Rails API only application that intends to power a Web Application build with Angular 4 and Mobile Application build with NativeScript

## Ruby and Rails Versions

Running with Ruby 2.4.1 and Rails 5.1.3 

## Development mode configuration

Open your system's hosts file with the command ```sudo -i gedit /etc/hosts``` and add the following lines:

```ruby
# Configure task manager api
127.0.0.1	api.task-manager.test
```
After saving the file, you will be able to access the endpoints providing http://api.task-manager.test:3000

## Running Tests

Spring will make tests run much faster
```shell
bundle exec spring rspec
```
