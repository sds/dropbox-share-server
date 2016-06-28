# Dropbox Share Server

Sometimes you just want to serve static files from your Dropbox.

A common example is serving your 1PasswordAnywhere web page so you can access
your encrypted passwords online.

## Getting Started

These installation instructions assume you already have Ruby installed on your system.
A simple way to get Ruby:

```bash
brew update
brew install rbenv ruby-build
rbenv init
rbenv install 2.3.1
```

1. Go to your Dropbox and create a "Share Link" for the folder you'd like to share.
   Remove the trailing `?dl=0` so it looks something like:
   `https://www.dropbox.com/sh/diuuhasnibrzc2r/ASniBrZC2rFxHaVzm31_Z3bIa`.

   ![Step 0](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/dropbox-step-0.png)

   ![Step 1](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/dropbox-step-1.png)

   ![Step 2](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/dropbox-step-2.png)

   Save this for later.

2. Create a Heroku account and create a new app within your account.

   ![Step 0](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/heroku-step-0.png)

   Navigate to your app settings page:

   ![Step 1](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/heroku-step-1.png)

   ![Step 2](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/heroku-step-2.png)

   Set the following configuration variables (`SHARE_LINK` is the link you created earlier):

   ![Step 3](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/heroku-step-3.png)

   Set the app to use the Ruby Buildback (`heroku/ruby`):

   ![Step 4](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/heroku-step-4.png)

   ![Step 5](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/heroku-step-5.png)

   If you are using a custom domain (requires a credit card for verification purposes):

   ![Step 6](https://raw.githubusercontent.com/sds/dropbox-share-server/master/docs/heroku-step-6.png)

3. Clone the repository

   ```bash
   git clone git://github.com/sds/dropbox-share-server.git
   cd dropbox-share-server
   ```

4. Log in to Heroku from the command line and push the repo to Heroku
   (you shouldn't need to change anything).

   ```bash
   gem install heroku
   heroku login
   heroku git:remote --app=my-onepw-app-name
   git push heroku master
   ```

5. You should be able to visit your website at `https://my-onepw-app-name.herokuapp.com`
