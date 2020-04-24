
include:
    - git
    - nodejs

aik-ui:
    git.latest:
     - name: https://github.com/icesi-ops/aik-portal
     - target: /srv/app
    require:
     - pkg: git

install_npm_dependencies:
    npm.bootstrap:
      - name: /srv/app/aik-app-ui

run_aik_portal:
    cmd.run:
      - name: "node /srv/app/aik-app-ui/server.js &" 

