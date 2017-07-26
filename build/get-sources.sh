PURPLE_HANGOUTS_VER=`curl -s https://bitbucket.org/EionRobb/purple-hangouts/downloads/ | grep "Download repository" | sed 's/.*get\///g' | sed 's/.zip.*//g'`

cd
echo "downloading https://bitbucket.org/EionRobb/purple-hangouts/get/${PURPLE_HANGOUTS_VER}.zip -----------------------------------------------------------"
curl https://bitbucket.org/EionRobb/purple-hangouts/get/${PURPLE_HANGOUTS_VER}.zip --output purple-hangouts.zip
