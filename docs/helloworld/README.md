# Hello World

This will walk you through installing the OpenWhisk CLI, deploying the [Hello World function](https://github.com/ibm-cds-labs/serverless-swift-app/blob/master/functions/HelloWorld.swift)
to OpenWhisk, launching the sample iOS app from Xcode, and calling the Hello World function.

## Prerequisites

1. Create or login to your Bluemix account.

2. Download the OpenWhisk CLI:
    1. Log in to Bluemix.
    2. Go to the [OpenWhisk CLI page](https://new-console.ng.bluemix.net/openwhisk/cli).
    3. Follow the instructions to Download and install the CLI.
    4. Copy the contents of **Set your OpenWhisk Namespace and Authorization Key** to your clipboard. You will need this in the next step.

3. Clone this repo and configure OpenWhisk:
    1. If you haven't already done so clone this repo.
	2. Create a file in *serverless-swift-app/deploy* called *wsk_set_env_prod.sh*.
	3. Paste the content from **step 2.d.** into *wsk_set_env_prod.sh*.
	4. Make sure *serverless-swift-app/deploy/wsk_set_env_prod.sh* is executable (`chmod +x serverless-swift-app/deploy/wsk_set_env_prod.sh`).

## OpenWhisk CLI

Follow these steps to make sure the OpenWhisk CLI is configured properly.

1. Open a Terminal and navigate to the repo directory.
2. Run the *deploy/wsk_set_env_prod.sh* script. This will set up your OpenWhisk CLI environment:

    `$ ./deploy/wsk_set_env_prod.sh`

3. Run following command:

    `$ wsk action list`

If you haven't uploaded or created any actions in OpenWhisk this will return an empty result.

## Deploy the Hello World Function to OpenWhisk

1. In the Terminal navigate to the deploy directory and run the *wsk_deploy_func_to_prod* script:

    ```
    $ cd serverless-swift-app/deploy
    $ ./wsk_deploy_func_to_prod create HelloWorld ../functions/HelloWorld.swift
    ```

2. Run `wsk action list` or go to [the OpenWhisk editor](https://new-console.ng.bluemix.net/openwhisk/editor) and confirm a new action called `HelloWorld` has been created.

## Test the Hello World Function

You can test the Hello World function in a few different ways:

1. From the OpenWhisk editor select the `HelloWorld` action and hit the **Run This Action** button. Your response should look similar to the following:

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

1. Open *serverless-swift-app/ServerlessSwiftTalk.xcworkspace* in Xcode 8.
2. Open the *HelloWorldViewController.swift* file in *client/ServerlessSwiftClient/ServerlessSwiftClient/View Controllers*.
3. Change the `OPENWHISK_ENDPOINT` var to point to your `HelloWorld` Function REST Endpoint.
Note: you can find the REST Enpoint by selecting the `HelloWorld` action in the OpenWhisk editor, and clicking **View REST Endpoint** in the bottom right.
4. Run *client/ServerlessSwiftClient* project in an iPhone 7 simulator. The app should look similar to the following:

![Hello World](ios_sim_helloworld.png?raw=true "Hello World")


