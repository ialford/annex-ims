#!/bin/sh
set -e

echo "Add github token so we can pull from private repos"
sudo -u app git config --global url."https://api:$OAUTHTOKEN@github.com/".insteadOf "https://github.com/"
sudo -u app git config --global url."https://ssh:$OAUTHTOKEN@github.com/".insteadOf "ssh://git@github.com/"
sudo -u app git config --global url."https://git:$OAUTHTOKEN@github.com/".insteadOf "git@github.com:"

echo "Change to $APP_DIR and run bundle install as app user"
cd $APP_DIR
# sudo -u app bundle update sassc
sudo -u app bundle install

echo "Create the mount folder for EFS and change permissions" 
mkdir -p "/efs"
chown app:app "/efs"
chmod 775 "/efs"

echo "Create symlink"
ln -s /efs/reports $APP_DIR/reports

echo "Create template files"
cp "$APP_DIR/config/secrets.yml.example" "$APP_DIR/config/secrets.yml"
cp "$APP_DIR/config/database.yml.example" "$APP_DIR/config/database.yml"

echo "Modify config file for database"
sed -i 's/{{ database_host }}/'"$DB_HOST"'/g' "$APP_DIR/config/database.yml"
sed -i 's/{{ database_username }}/'"$DB_USER"'/g' "$APP_DIR/config/database.yml"
sed -i 's/{{ database_password }}/'"$DB_PASSWORD"'/g' "$APP_DIR/config/database.yml"
sed -i 's/{{ database_name }}/'"$DB_NAME"'/g' "$APP_DIR/config/database.yml"

echo "Modify config file for secrets"
sed -i 's/{{ auth_server_id }}/'"$AUTH_SERVER_ID"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ client_id }}/'"$CLIENT_ID"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ client_secret }}/'"$CLIENT_SECRET"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ secret_key_base }}/'"$SECRET_KEY_BASE"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ host_name }}/'"$HOST_NAME"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ api_token }}/'"$API_TOKEN"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ coral_password }}/'"$CORAL_PASSWORD"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ service_password }}/'"$SERVICE_PASSWORD"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ refworks_password }}/'"$REFWORKS_PASSWORD"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ sentrydn }}/'"$SENTRYDN"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ illiad_password }}/'"$ILLIAD_PASSWORD"'/g' "$APP_DIR/config/secrets.yml"
sed -i 's/{{ rabbitmq_host }}/'"$RABBITMQ_HOST"'/g' "$APP_DIR/config/secrets.yml"

echo "Modify sunspot file for solr"
sed -i 's/{{ solr_host }}/'"$SOLR_HOST"'/g' "$APP_DIR/config/sunspot.yml"

echo "Modify webapp config file for PASSENGER_APP_ENV setting"
sed -i 's/{{ passenger_app_env }}/'"$PASSENGER_APP_ENV"'/g' "/etc/nginx/sites-enabled/webapp.conf"

echo "Run the assests precompile rake job"
RAILS_ENV=$PASSENGER_APP_ENV bundle exec rake assets:precompile

echo "Fix permissions on $APP_DIR folder"
chown -R app:app $APP_DIR

echo "Check the RUN_SCHEDULED_TASKS to see if we need to run them"
if [[ $RUN_TASKS = "1" ]]; then
    echo "Check the time and run the appropriate Notify job"
    if [[ $(date -d "now + 0 minutes" +'%H') = "05" ]]; then
        echo "Run the rails runner NotifyReserveRequestor job"
        RAILS_ENV=$PASSENGER_APP_ENV bundle exec rake annex:run_scheduled_reports
    else
        echo "Run the rake sneakers:ensure_running job"
        RAILS_ENV=$PASSENGER_APP_ENV bundle exec rake sneakers:ensure_running
        echo "Run the rake annex:get_active_requests job"
        RAILS_ENV=$PASSENGER_APP_ENV bundle exec rake annex:get_active_requests
        echo "Rake jobs completed"
    fi
else
    echo "Start Passenger Service as $PASSENGER_APP_ENV"
    exec /sbin/my_init
fi