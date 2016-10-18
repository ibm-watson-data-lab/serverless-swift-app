# Overview

This repository contains a sample iOS app developed in Swift and an app backend developed using Serverless Swift functions.

## Goals

The primary goal of this project was to develop and deploy a fully featured app backend in Swift and deploy on OpenWhisk.
The sample provides the ability to:

1. Register as a new user - this demonstrates how you can use a serverless function to connect and save information to a database.
2. Login as the newly created user - this demonstrates how you can provide authentication and authorization services in a serverless infrastructure.
3. Retrieve the logged in user's profile - this demonstrates how you can identify a user in a stateless serverless environment without sessions or cookies.
4. Login using a 3rd party provider - this demonstrates how you can use OAuth2 with serverless functions, in this case we login using GitHub.
5. Retrieve the logged in user's profile from the 3rd party - this demonstrates how you can make API calls to the 3rd party authentication system to retrieve profile information.

## Other Goals

## Where to Start

The best place to start is by deploying the [Hello World example](docs/helloworld/).
This will walk you through installing the OpenWhisk CLI, deploying your first Swift function to OpenWhisk
using a custom bash script (we'll explain why later), launching the sample iOS app from Xcode, and executing
your Swift function.
