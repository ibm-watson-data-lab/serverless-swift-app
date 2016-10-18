# Hello World

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

## Deploy the Hello World Function to OpenWhisk

1. Open Terminal and run the following commands:

```
cd serverless-swift-app/deploy
./wsk_deploy_func_to_prod create HelloWorld ../functions/HelloWorld.swift
```

2. Run `wsk list` or go to [the OpenWhisk editor](https://new-console.ng.bluemix.net/openwhisk/editor) and confirm a new action called `HelloWorld` has been created.

## Test the Hello World Function

You can test the Hello World function in a few different ways:

1. From the OpenWhisk editor select the `HelloWorld` action and hit the *Run This Action* button. Your response should look similar to the following:

```
{
    "reply": "Hello stranger!"
}
```

2. From the Terminal run `wsk action invoke -b HelloWorld`. Your response should look similar to the following:

```
ok: invoked HelloWorld with id 5f57c501503747269ee2dd74ed0c2bf0
{
    "activationId": "5f57c501503747269ee2dd74ed0c2bf0",
    "annotations": [
        {
            "key": "limits",
            "value": {
                "logs": 10,
                "memory": 256,
                "timeout": 180000
            }
        },
        {
            "key": "path",
            "value": "<BLUEMIX_ID>_<BLUEMIX_SPACE>/HelloWorld"
        }
    ],
    "end": 1476221243388,
    "logs": [],
    "name": "HelloWorld",
    "namespace": "BLUEMIX_ID",
    "publish": false,
    "response": {
        "result": {
            "reply": "Hello stranger!"
        },
        "status": "success",
        "success": true
    },
    "start": 1476221243350,
    "subject": "BLUEMIX_ID",
    "version": "0.0.3"
}
```

## Test the Hello World Function from the iOS app

1. Open _serverless-swift-app/ServerlessSwiftTalk.xcworkspace_ in Xcode 8.
2. Open the _HelloWorldViewController.swift_ file in _client/ServerlessSwiftTalkClient/ServerlessSwiftTalkClient/View Controllers_.
3. Change the `OPENWHISK_ENDPOINT` var to point to your `HelloWorld` Function REST Endpoint. Note: you can find the REST Enpoint by selecting the `HelloWorld` action in the OpenWhisk editor, and clicking _View REST Endpoint_ in the bottom right.
4. Run _client/ServerlessSwiftTalkClient_ project in an iPhone 7 simulator.

