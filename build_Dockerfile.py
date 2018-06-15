#!/usr/bin/env python3

import requests
import re

repos = { "bitlbee": 
        {"repo": "bitlbee/bitlbee",
        },
        "discord":
        {"repo": "EionRobb/purple-discord",
        },
         "facebook":
        {"repo": "bitlbee/bitlbee-facebook",
        },
         "skype4pidgin":
        {"repo": "EionRobb/skype4pidgin",
        },
         "slack-libpurple":
        {"repo": "dylex/slack-libpurple",
        },
         "telegram-purple":
        {"repo": "majn/telegram-purple",
        },
}

def getHashLastCommit(repo_name):
    api_url = "https://api.github.com/repos/" + repos[repo_name]["repo"] + "/commits/master"
    r = requests.get(api_url)
    return r.json()["sha"][0:7]

bitlbee_commit = getHashLastCommit("bitlbee")
discord_commit = getHashLastCommit("discord")
facebook_commit = getHashLastCommit("facebook")
skype_commit = getHashLastCommit("skype4pidgin")
slack_commit = getHashLastCommit("slack-libpurple")
telegram_commit = getHashLastCommit("telegram-purple")

file_handle = open("Dockerfile.template", 'r')
file_string = file_handle.read()
file_handle.close()
file_string = (re.sub("bitlbee_commit", bitlbee_commit, file_string))
file_string = (re.sub("discord_commit", discord_commit, file_string))
file_string = (re.sub("facebook_commit", facebook_commit, file_string))
file_string = (re.sub("skype_commit", skype_commit, file_string))
file_string = (re.sub("slack_commit", slack_commit, file_string))
file_string = (re.sub("telegram_commit", telegram_commit, file_string))

file_handle = open("bitlbee/Dockerfile", 'w')
file_handle.write(file_string)
file_handle.close()
