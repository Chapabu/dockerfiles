#!/bin/bash
set -xe

if [ -L "$0" ] ; then
    DIR="$(dirname "$(readlink -f "$0")")" ;
else
    DIR="$(dirname "$0")" ;
fi ;

source "$DIR/common_functions.sh";

cd /app || exit 1;

if [ ! -d "/app/vendor" ] || [ ! -f "/app/vendor/autoload.php" ]; then
  if [ -n "$GITHUB_TOKEN" ]; then
    as_build "composer config github-oauth.github.com '$GITHUB_TOKEN'"
  fi

  as_build "composer install --optimize-autoloader --no-interaction"
  as_build "composer clear-cache"

  chmod -R go-w vendor
fi

cd /app/docroot || exit 1;

SETTINGS_DIR="/app/docroot/sites/default"

if [ ! -d "$SETTINGS_DIR/files/" ]; then
  chmod u+w "$SETTINGS_DIR" || true
  mkdir -p "$SETTINGS_DIR/files/"
  as_build "drush site-install lightning -vvv", "/app/docroot"
fi

if [ ! -f "$SETTINGS_DIR/settings.php" ]; then
  mkdir -p "$SETTINGS_DIR"
  chmod u+w "$SETTINGS_DIR"
  cp /app/tools/docker/config/settings.php "$SETTINGS_DIR/settings.php"
  chmod go-w "$SETTINGS_DIR/settings.php"
  chmod a-w "$SETTINGS_DIR"
fi

if [ ! -f "$SETTINGS_DIR/services.yml" ]; then
  mkdir -p "$SETTINGS_DIR"
  chmod u+w "$SETTINGS_DIR"

  SOURCE_FILE="$SETTINGS_DIR/default.services.yml"
  if [ -f /app/tools/docker/config/services.yml ]; then
    SOURCE_FILE="/app/tools/docker/config/services.yml"
  fi

  cp "$SOURCE_FILE" "$SETTINGS_DIR/services.yml"
  chmod go-w "$SETTINGS_DIR/services.yml"

  chmod a-w "$SETTINGS_DIR"
fi
