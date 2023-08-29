## Install

Prepare docker

```bash
git clone https://github.com/ahmadrosid/BotBuddy.git
cd BotBuddy/
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
sudo apt install make
```

Update some config and install docker containers

Add your openai apikey

```bash
bash replace.sh -i common.env -f 'OPENAI_API_KEY=' -t 'OPENAI_API_KEY=sk...'
```

Update your host url

```bash
bash replace.sh -i backend-server/public/chat.js -f 'localhost:8000' -t 'example.com...'
make install
```

Run worker so that crawling, indexing pdf etc will works.

```bash
make run-worker
```

## Fix chat.js baseUrl

```bash
bash replace.sh -i backend-server/public/chat.js -f 'localhost:8000' -t 'example.com...'
```
