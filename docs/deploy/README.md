# Deployment

The OpenWhisk CLI provides commands for creating and updating functions (actions) in OpenWhisk.
In the _serverless-swift-app/deploy_ there are custom scripts that use the OpenWhisk CLI
to help simplify deployment of Swift functions.

## Setting up your Environment

1. Download the OpenWhisk CLI
    1. Log in to Bluemix and go [here](https://new-console.ng.bluemix.net/openwhisk/cli).
    2. Follow the instructions to Download the CLI.
    3. Copy the contents of _Set your OpenWhisk Namespace and Authorization Key_. You will need this in the next step.

2. Clone this repo and configure OpenWhisk
    1. If you haven't already done so clone this repo.
	2. Create a file in _serverless-swift-app/deploy_ called _wsk_set_env_prod.sh_.
	3. Paste the content from **step 1.c.** into _wsk_set_env_prod.sh_.
	4. Make sure _serverless-swift-app/deploy/wsk_set_env_prod.sh_ is executable (`chmod +x serverless-swift-app/deploy/wsk_set_env_prod.sh`).

## Deploying functions

Use the _deploy/wsk_deploy_func_to_prod.sh_ script to deploy your functions to OpenWhisk. 
This script provides features that are required to effectively upload the functions in this product.
You cannot upload the functions using the OpenWhisk CLI only.

##  Embedding Libraries

As of this writing OpenWhisk does not support bundling of Swift libraries with your functions. 
We have worked around this limitation by allowing you to embed other Swift files in your functions.
The _wsk_deploy_func_to_prod.sh_ will run your Swift function through the [Jinja2 Template Engine](http://jinja.pocoo.org/).
This allows you to add includes to your Swift functions. The contents of the included files will be embedded
in the function prior to uploading to OpenWhisk.

For example, the _Register_ function has the following includes:

```
{% include "./lib/couchdb/CouchDBCreateDbResponse.swift" %}
{% include "./lib/couchdb/CouchDBSaveDocResponse.swift" %}
{% include "./lib/couchdb/CouchDBClient.swift" %}
```

## Parameters

You can store static parameters with your OpenWhisk functions. These are ideal for storing things like
database connection strings, passwords, or any setting that you don't want to hard-code in your function.
These parameters are passed into your function when it is executed.

For example, if you store a parameter with your function called `connectionString` and execute your function with the following params:

```
[
	"variable1": "value",
	"variable2": "value"
]
```

OpenWhisk will add the `connectionString` parameter and your function will actually be executed with the following params:

```
[
	"connectionString": "XXX",
	"variable1": "value",
	"variable2": "value"
]
```

The _wsk_deploy_func_to_prod.sh_ will search your Swift function for a list of parameters that are used by that function,
read the parameters from _serverless-swift-app/params/default_params_prod.txt_, and automatically send them when creating or updating
your function with OpenWhisk.
