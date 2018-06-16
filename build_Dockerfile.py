#!/usr/bin/env python3

import requests
import re

github_repos = { "bitlbee": 
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

bitbucket_repos = { "purple-hangouts":
        {"repo": "EionRobb/purple-hangouts",},
        }

def getHashLastCommitGithub(repo_name):
    api_url = "https://api.github.com/repos/" + github_repos[repo_name]["repo"] + "/commits/master"
    r = requests.get(api_url)
    return r.json()["sha"][0:7]

def getHashLastCommitBitbucket(repo_name):
    api_url = "https://api.bitbucket.org/2.0/repositories/" + bitbucket_repos[repo_name]["repo"] + "/commits/default"
    r = requests.get(api_url)
    return r.json()['values'][0]['hash'][0:7]

bitlbee_commit = getHashLastCommitGithub("bitlbee")
discord_commit = getHashLastCommitGithub("discord")
facebook_commit = getHashLastCommitGithub("facebook")
skype_commit = getHashLastCommitGithub("skype4pidgin")
slack_commit = getHashLastCommitGithub("slack-libpurple")
telegram_commit = getHashLastCommitGithub("telegram-purple")

hangouts_commit = getHashLastCommitBitbucket("purple-hangouts")

file_handle = open("Dockerfile.template", 'r')
file_string = file_handle.read()
file_handle.close()
file_string = (re.sub("bitlbee_commit", bitlbee_commit, file_string))
file_string = (re.sub("discord_commit", discord_commit, file_string))
file_string = (re.sub("facebook_commit", facebook_commit, file_string))
file_string = (re.sub("skype_commit", skype_commit, file_string))
file_string = (re.sub("slack_commit", slack_commit, file_string))
file_string = (re.sub("telegram_commit", telegram_commit, file_string))

file_string = (re.sub("hangouts_commit", hangouts_commit, file_string))

file_handle = open("bitlbee/Dockerfile", 'w')
file_handle.write(file_string)
file_handle.close()
