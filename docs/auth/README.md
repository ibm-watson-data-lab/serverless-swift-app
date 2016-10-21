# Authentication and Authorization

Many iOS apps will require that users register and login to access certain features.
In some cases you will want to provide a custom registration/login process while in others
you may allow users to login using a 3rd party service like Facebook or Google.

In this sample we have provided both types of examples. The sample iOS has a registration view for custom
registration/login and a login view which shows you how to login with a custom user account or login via GitHub.

## Prerequisites

1. Create a Bluemix account

2. Download the OpenWhisk CLI:
    1. Log in to Bluemix.
    2. Go to the [OpenWhisk CLI page](https://new-console.ng.bluemix.net/openwhisk/cli).
    3. Follow the instructions to Download and install the CLI.
    4. Copy the contents of **Set your OpenWhisk Namespace and Authorization Key** to your clipboard. You will need this in the next step.

3. Clone this repo and configure OpenWhisk:
    1. If you haven't already done so clone this repo.
	2. Create a file in *serverless-swift-app/deploy* called *wsk_set_env_prod.sh*.
	3. Paste the content from **step 2.iv.** into *wsk_set_env_prod.sh*.
	4. Make sure *serverless-swift-app/deploy/wsk_set_env_prod.sh* is executable (`chmod +x serverless-swift-app/deploy/wsk_set_env_prod.sh`).

## Custom Authentication

To test Custom Authentication follow the instructions in the  
[Custom Authentication README](https://github.com/ibm-cds-labs/serverless-swift-app/tree/master/docs/auth/CustomAuthentication.md).

## GitHub Authentication

To test GitHub Authentication follow the instructions in the 
[GitHub Authentication README](https://github.com/ibm-cds-labs/serverless-swift-app/tree/master/docs/auth/GitHubAuthentication.md).