# MASHREQ IMBOT CLI v.0.0.1 - beta 

# function updateRepo()
# {
#     #!/bin/sh
#     git add .
#     git commit -m "uploading changes."
# UPSTREAM=${1:-'@{u}'}
# echo $UPSTREAM
# LOCAL=$(cd out/bp/data && git rev-parse @)
# REMOTE=$(cd out/bp/data && git rev-parse "$UPSTREAM")
# BASE=$(cd out/bp/data && git merge-base @ "$UPSTREAM")

# if [ $LOCAL = $REMOTE ]; then
#     echo "Up-to-date"
# elif [ $LOCAL = $BASE ]; then
#     echo "Need to pull"
# elif [ $REMOTE = $BASE ]; then
#     echo "Need to push"
# else
#     echo "Diverged"
# fi
# }
branch="mashreqneo"
# admin="mashreq.moeid@gmail.com"
admin = "jijeshpo@mashreq.com"
user_email=$( git config user.email)

function create_package()
{
    cd modules/whatsapp-module/ && ./node_modules/.bin/module-builder package || echo 'failed to run the command....'
    cp ./modules/whatsapp-module/whatsapp-module_1_0_0.tgz  ./out/bp/data/modules/ && cp ./out/bp/assets/ ./out/bp/data/assets/ &&  cp release.sh ./out/bp/data/
}

function compile()
{
  if $1 = true; then             
          if [ -d "./out/bp/data/modules/" ]
              then
              # Control will enter here if $DIRECTORY exists.
              rm -rf ./out/bp/data/modules/
              echo "Removing Modules folder in data"
            fi
         echo "recompiling whatsapp-modules...."
         mkdir ./out/bp/data/modules && create_package
         cd ./out/bp/data/ && git add . && git commit -m ':fire: updating new release build :construction:'  && git push origin "${branch}"
        else 
        cd ./out/bp/data/ && git add . && git commit -m ':fire: updating new release build :construction:'  && git push origin "${branch}"

  fi
break

}



# updateRepo
echo "#---------------------------------#\n#################################\nWelcome! to Mashreq IMBot CLI ^_^ \n#################################\n#---------------------------------#\n"
say 'welcome to Mashreq IM Bot CLI'

options=("Recompile" "Deploy" "About" "Quit")
optionsx=("release" "mashreqneo" "next" "master")


select opt in "${options[@]}"
do
    case $opt in
        "Recompile")
            say 'Re compiling'
            echo "\nRecompiling..."
            compile true
            break
            ;;
        "Deploy")
            echo "Please select the branch"
            say 'Please select a branch to deploy changes'
            select abc in "${optionsx[@]}"
            do 
                case $abc in 
                "release")
                echo "selecting origin/release ...."
                $branch="release"
                compile false
                break
                ;;
                "mashreqneo")
                echo "selecting origin/mashreqneo ...."
                $branch="mashreqneo"
                compile false
                break
                ;;
                "next")
                echo "selecting origin/next ...."
                 $branch="next"
                compile false
                break
                ;;
                "master")
                if [ "$user_email" == "$admin" ];then 
                echo "Administrator right detected for ${user_email} - ${admin}.. \n Publishing to master"
                $branch="mashreqneo"
                compile false
                break
                else
                  echo "Sorry! User ${user_email} does not have access to publish to master branch. \n\n"
                  say "Sorry! User does not have access to publish to master branch. Contact Support."
                  break
                fi  
                ;;
                *) echo " testing new things"
                esac
            done 
              break
            ;;
            "About")
        echo "Mashreq IMBot CLI v.0.0.2"
        say "Mashreq CLI IMBot is a next generation chat bot that handle all your digital banking needs easily! You can get more information about at www dot mashreq bank dot com!"
            break
            ;;
        "Quit")
        echo "Thankyou for using MashreqBot CLI"
        say "Thankyou for using MashreqBot CLI"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

