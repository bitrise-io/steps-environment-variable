#!/bin/bash

echo "Environment Key: $ENVIRONMENT_KEY"
echo "Environment Value: $ENVIRONMENT_VALUE"

echo "export $ENVIRONMENT_KEY=\"$ENVIRONMENT_VALUE\"" >> ~/bashprof.txt