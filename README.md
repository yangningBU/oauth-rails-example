# OAuth Test App

Unfortunately this example lugs around a huge unnecessary Rails app. But the principle works.

## Code Setup
- download the repo
- install rails with `gem install rails`
- then install the project dependencies with `bundle install`
- turn on the server with `rails s`
- then open your broswer to http://lvh.me:8000/

## Github Setup
- log into your Github account, click on your user icon, and then Settings
- click on "Github Apps" under Developer settings in the bottom left:
<img src="/public/oauth-github-setup-0.png" alt="Github Apps Link" width="300px"/>
- click on "generate new app" and fill in something like this:
<img src="/public/oauth-github-setup-1.png" alt="Oauth App Create Page Filled Out" width="300px"/>
- it's important that the home page URL and callback URL match what you have in your app routing
- go through the "webhook" setup flow since it's required by Github, but we're not using it in this example

<br/>
*Note*: since I'm doing this all locally, I'm using a hack with the `lvh.me` domain whose DNS is mapped to 127.0.0.1. This will probably break at some point
