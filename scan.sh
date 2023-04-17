#!/bin/bash

rm -rf node_modules

rm package-lock.json

npm install 

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i angapp_dir_nodemods .

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i angapp_lockfile_nodemods package-lock.json
  
rm -rf node_modules

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i angapp_dir_nonodemods .

nexus-iq-cli -s http://localhost:8070 -a admin:admin123 -i angapp_lockfile_nonodemods package-lock.json

