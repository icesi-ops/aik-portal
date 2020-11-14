include:
  - nodejs
  - aik-ui
install_back_npm_dependencies:
  npm.bootstrap:
    - name: /srv/app/aik-app-api

run_aik_back_portal:
  cmd.run:
    - name: "nohup node /srv/app/aik-app-api/server.js > output.log &"
