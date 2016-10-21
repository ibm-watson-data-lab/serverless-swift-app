# Custom Authentication and Authorization

In some cases you may want to provide a custom registration and login process from your iOS app.
This example shows you how to:

1. Register as a new user and store user information in your own Cloudant database.
2. Login as a user by validating the user's email address and password against your Cloudant database.
3. Access secure data that only that user should have access to (in this case the user's profile).   

### Configure Cloudant

The custom registration process stores users in a Cloudant database. If you don't have a Cloudant database
login to your Bluemix account and provision one. Find the credentials for your Cloudant database and configure your
connection information as follows:

1. Copy *serverless-swift-app/params/default_params_template.txt* to *serverless-swift-app/params/default_params_prod.txt*
2. In *default_params_prod.txt* fill in the connection details to your Cloudant or CouchDB database.

### Deploy the Login, Register, and Profile Functions to OpenWhisk

1. Open Terminal and run the following commands:

```
cd serverless-swift-app/deploy
./wsk_deploy_func_to_prod create Register ../functions/Register.swift
./wsk_deploy_func_to_prod create Login ../functions/Login.swift
./wsk_deploy_func_to_prod create Profile ../functions/Profile.swift
```

2. Run `wsk action list` or go to [the OpenWhisk editor](https://new-console.ng.bluemix.net/openwhisk/editor) and confirm there are three new actions called `Register`, `Login`, and `Profile`.

## Test the Register Function from the iOS app

1. Open *serverless-swift-app/ServerlessSwiftTalk.xcworkspace* in Xcode 8.
2. Open the *RegisterViewController.swift* file in *client/ServerlessSwiftClient/ServerlessSwiftClient/View Controllers*.
3. Change the `OPENWHISK_ENDPOINT` var to point to your `Register` Function REST Endpoint. Note: you can find the REST Enpoint by selecting the `Register` action in the OpenWhisk editor, and clicking **View REST Endpoint** in the bottom right.
4. Run *client/ServerlessSwiftClient* project in an iPhone 7 simulator.
5. Tap the **Register** tab on the bottom.
6. Fill in an **Email address**, **Password**, **First Name**, and **Last Name** and tap **Run with OpenWhisk**
7. If successful, you should see an alert similar to the following:

TBD

## Test the Login Function from iOS app

After you have registered a user (and there is a new document representing that user in your Cloudant users database) following
these instructions to Login:

1. Open the *LoginViewController.swift* file and set the `OPENWHISK_ENDPOINT` var to the appropriate value.
2. Run *client/ServerlessSwiftClient* project in an iPhone 7 simulator.
3. Tap the **Login** tab on the bottom.
4. Fill in the **Email address** and **Password** for your user and tap **Run with OpenWhisk**

## Test the Profile Function from iOS app

When you logged in in the previous step the OpenWhisk function returned a [JSON Web Token](http://www.jsonwebtoken.com)
to the iOS app, and that token was saved in memory. This token is required by the Profile Function on the serverless
to verify the identity of the user.

To test Profile follow these instructions: 

1. Make sure you have logged in using the steps above.
2. Open the *ProfileViewController.swift* file and set the `OPENWHISK_ENDPOINT` var to the appropriate value.
3. Run *client/ServerlessSwiftClient* project in an iPhone 7 simulator.
4. Tap the **Profile** tab on the bottom.
5. Tap **Run with OpenWhisk**

