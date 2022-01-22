#!/bin/bash

mkdir -p '/config/crafty/db' '/config/crafty/config' '/config/crafty/servers'

config_filepath='/config/crafty/config/docker_config.yml'

# copy example config file
if [ ! -f "${config_filepath}" ]; then
	cp '/opt/crafty/configs/docker_config.yml' "${config_filepath}"
fi

# modify config file
###

# tells crafty if it should activate the console and not loop forever
#sed -i -E "s~daemon_mode: true~daemon_mode: false~g" "${config_filepath}"

# tells crafty where to store the database it creates
sed -i -E 's~db_dir: "/crafty_db"~db_dir: "/config/crafty/db"~g' "${config_filepath}"

# symlink certs to config
source '/usr/local/bin/utils.sh' && symlink --src-path '/opt/crafty/app/web/certs' --dst-path '/config/crafty/certs' --link-type 'softlink' --log-level 'WARN'

# symlink backups to config
source '/usr/local/bin/utils.sh' && symlink --src-path '/opt/crafty/backups' --dst-path '/config/crafty/backups' --link-type 'softlink' --log-level 'WARN'

# run crafty in virtualenv
cd '/opt/crafty' && source './env/bin/activate' && python3 '/opt/crafty/crafty.py' --config "${config_filepath}"