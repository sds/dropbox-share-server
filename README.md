# Dropbox Share Server

Sometimes you just want to serve static files from your Dropbox.

A common example is serving your [1PasswordAnywhere][1PA] web page so you can access
your encrypted passwords online.

[1PA]: https://discussions.agilebits.com/discussion/63045/moving-beyond-1passwordanywhere)

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

## Frequently Asked Questions

* *Why not just use the `Public` folder in Dropbox?*

  You can totally do this, but then you'll need to either copy the files from
  their current location in your Dropbox to the Public folder (and figure out
  how to keep them in sync&mdash;note that symlinks won't work!) or just store
  them solely in your Public folder (which may conflict with how you like the
  organizational structure of your Dropbox).

  You'll also need a way to host the files at a URL you can remember. The
  links for publicly-shared files in Dropbox aren't the easiest to remember.

  Using Heroku gives you an easily-remembered URL and also creates an offline
  backup of your files should you somehow lose access to your Dropbox (or in the
  unlikely event Dropbox is down).

* *How are files synced?*

  When the server first starts up, it downloads a ZIP of the folder you shared.
  For this reason it shouldn't be used for sharing large folders (a few MB for
  best results).

  As long as you keep making requests within a specified threshold (default
  5 minutes), the files will be automatically synced in the background at
  some interval (every 30 seconds by default).

## License

This project is released under the [MIT license](LICENSE.md).
