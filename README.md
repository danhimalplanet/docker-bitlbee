## Installation

# build from Dockerfile on github
`docker build -t="danhimalplanet/docker-bitlbee" github.com/danhimalplanet/docker-bitlbee/`

# or build locally
# customize etc/bitlbee/bitlbee.conf to suit your needs
`docker build -t="danhimalplanet/docker-bitlbee" docker-bitlbee/`

## Usage

### run bitlbee

`docker run -d --name bitlbee -p 16667:6667 --restart=always danhimalplanet/docker-bitlbee:latest`

### run bitlbee with persistent config file (`username.xml`) in /home/danh/bitlbee/
 
`docker run -d --name bitlbee -p 16667:6667 --restart=always -v /var/lib/bitlbee:/var/lib/bitlbee danhimalplanet/docker-bitlbee:latest`

### run bitlbee with persistent config file (`username.xml`) in /home/danh/bitlbee/ when selinux is on in the host

`docker run -d --name bitlbee -p 16667:6667 --restart=always -v /var/lib/bitlbee:/var/lib/bitlbee:z danhimalplanet/docker-bitlbee:latest`

