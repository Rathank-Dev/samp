#!/bin/bash
sleep 3

cd /home/container

export INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')

echo "Configuring SA:MP server with dynamic IP and port..."

# Ensure server.cfg exists
if [ ! -f "server.cfg" ]; then
    echo "Error: server.cfg not found!"
    exit 1
fi

# Replace existing IP and port in server.cfg with values from Pterodactyl
sed -i "s/^port .*/port ${SERVER_PORT}/" server.cfg
sed -i "s/^bind .*/bind 0.0.0.0/" server.cfg  # Keep IP dynamic

echo "Updated server.cfg:"
cat server.cfg

# Execute the startup command from Pterodactyl
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}
