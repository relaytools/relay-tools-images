#!/bin/bash -e

##
### This script handles the configuration state for a deployment of relay tools.  It assumes that the images have been built or downloaded already.
##

# Launch sequence:

# Mysql first.

machinectl start mysql

# keys-certs-manager second?

