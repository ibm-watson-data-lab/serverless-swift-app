FROM markwatsonatx/swift-kitura-sample:0.32

RUN apt-get update
RUN apt-get install -y inotify-tools python-pip python-dev build-essential
RUN apt-get -y install autoconf libtool libkqueue-dev libkqueue0 libdispatch-dev libdispatch0 libcurl4-openssl-dev libbsd-dev
RUN pip install j2cli