# log $1 in underline green then $2 in yellow
log() {
    echo -e "\033[1;4;32m$1\033[0m \033[1;33m$2\033[0m"
}


# skip `yum install --assumeyes jq` because it first
# updates `yum` and is takes way too much time !
log install 'stedolan/jq'
cp /var/task/jq /usr/local/bin/
which jq


log install 'tj/node-prune'
cp /var/task/node-prune /usr/local/bin/
which node-prune


log install 'tj/n'
curl --location \
    --remote-name \
    https://raw.githubusercontent.com/tj/n/master/bin/n


# change `lts` with `10`, `12`, ...
log install "node lts"
bash n lts

log install sharp
npm init --yes
npm install sharp

log execute node-prune
node-prune

NODE_VERSION=$(node --version \
    | sed --expression 's|v||' \
        --expression 's|\..*||')
SHARP_VERSION=$(npm ls sharp --json \
    | jq '.dependencies.sharp.version' --raw-output)

mkdir nodejs
mv node_modules nodejs/

ZIP=sharp-${SHARP_VERSION}-for-node-${NODE_VERSION}.zip
log create $ZIP
zip $ZIP -r9 nodejs

useradd $HOST_USER
chown $HOST_USER:$HOST_USER $ZIP
mv $ZIP /var/task/


