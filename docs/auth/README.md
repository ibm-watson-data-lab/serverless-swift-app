# Authentication and Authorization

Many iOS apps will require that users register and login to access certain features.
In some cases you will want to provide a custom registration/login process while in others
you may allow users to login using a 3rd party service like Facebook or Google.

In this sample we have provided both types of examples. The sample iOS has a registration view for custom
registration/login and a login view which shows you how to login with a custom user account or login via GitHub.

## Prerequisites

1. Create a Bluemix account

2. Download the OpenWhisk CLI
    1. Log in to Bluemix and go [here](https://new-console.ng.bluemix.net/openwhisk/cli).
    2. Follow the instructions to Download the CLI.
    3. Copy the contents of _Set your OpenWhisk Namespace and Authorization Key_. You will need this in the next step.

3. Clone this repo and configure OpenWhisk
    1. If you haven't already done so clone this repo.
	2. Create a file in _serverless-swift-app/deploy_ called _wsk_set_env_prod.sh_.
	3. Paste the content from *step 2.c.* into _wsk_set_env_prod.sh_.
	4. Make sure _serverless-swift-app/deploy/wsk_set_env_prod.sh_ is executable (`chmod +x serverless-swift-app/deploy/wsk_set_env_prod.sh`).

## Custom Registration/Authentication

### Configure Cloudant

The custom registration process stores users in a Cloudant database.

1. Copy _serverless-swift-app/params/default_params_template.txt_ to _serverless-swift-app/params/default_params_prod.txt_
2. In _default_params_prod.txt_ fill in the connection details to your Cloudant or CouchDB database. 

### Deploy the Login, Register, and Profile Functions to OpenWhisk

1. Open Terminal and run the following commands:

```
cd serverless-swift-app/deploy
./wsk_deploy_func_to_prod create Register ../functions/Register.swift
./wsk_deploy_func_to_prod create Login ../functions/Login.swift
./wsk_deploy_func_to_prod create Profile ../functions/Profile.swift
```

2. Run `wsk list` or go to [the OpenWhisk editor](https://new-console.ng.bluemix.net/openwhisk/editor) and confirm there are three new actions called `Register`, `Login`, and `Profile`.

## Test the Register Function from the iOS app

1. Open _serverless-swift-app/ServerlessSwiftTalk.xcworkspace_ in Xcode 8.
2. Open the _RegisterViewController.swift_ file in _client/ServerlessSwiftClient/ServerlessSwiftClient/View Controllers_.
3. Change the `OPENWHISK_ENDPOINT` var to point to your `HelloWorld` Function REST Endpoint. Note: you can find the REST Enpoint by selecting the `HelloWorld` action in the OpenWhisk editor, and clicking _View REST Endpoint_ in the bottom right.
4. Run _client/ServerlessSwiftClient_ project in an iPhone 7 simulator.

