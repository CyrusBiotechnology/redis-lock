#!/bin/sh

npm config set registry https://cyrusbio.jfrog.io/cyrusbio/api/npm/cyrus-npm/
encoded_auth=`echo -n ${ARTI_NAME}:${ARTI_PASS} | openssl base64`
echo "_auth = $encoded_auth" >> ~/.npmrc
echo "email = sudo@cyrusbio.com" >> ~/.npmrc
echo "always-auth = true" >> ~/.npmrc

npm publish
