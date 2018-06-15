* run build_Dockerfile.py to build Dockerfile that builds:

latest biblbee
latest Eionrobb libpurple discord
latest bitlbee facebook
latest Eionroob skype4pidgin
latest dylex libpurple slack
latest majn libpurple telegram

repo master branch latest commit hash changed in Dockerfile hopefully only
on new commit, to take advantage of docker build caching

* docker build -t bitlbee:latest bitlbee/.
