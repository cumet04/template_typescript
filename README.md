## Usage

### Create and enter a environment
```
$ cd .devcontainer
$ docker compose up -d
$ docker compose exec app /bin/bash
```

### Update node version
```
$ ./.devcontainer/update_environments.sh
$ npm install
```

### Update dependencies
```
$ npx npm-check-updates
```
