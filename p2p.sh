#!/bin/bash
mail=$1
if [[ $UID -ne 0 ]]; then  
    bin="/bin/p2pclient"
else
    bin="${PWD}/p2pclient"
fi
if [[ -z $mail ]]; then  
    echo "Please input mail." 
    exit  
fi
if [[ -z $(command -v /bin/p2pclient) ]];then
    url="https://github.com/haoduck/files/raw/main/p2pclient-upx"
    # bin="/bin/p2pclient"
    if [[ -z $(command -v wget) ]];then
        wget -q $url -O $bin
    elif [[ -z $(command -v curl) ]];then
        curl -sL $url -o $bin
    else
        if [[ $(command -v apt) ]];then
            apt update
            apt install wget -y
        elif [[ $(command -v yum) ]];then
            yum install wget -y
        elif [[ $(command -v apk) ]];then
            apk add wget
        else
            echo "wget/curl not fount."
            exit 1
        fi
        wget -q $url -O $bin
    fi
    chmod +x $bin
    $bin -l $mail
else
    chmod +x $bin
    $bin -l $mail
fi

cmd="nohup $bin -l $mail >/dev/null 2>&1 &"

if [[ -f $HOME/.bashrc ]];then
    if [[ -z "$(cat $HOME/.bashrc|grep $bin)" ]];then
        echo -e "\n\n$cmd\n" >> $HOME/.bashrc
    fi
elif [[ -f $HOME/.profile]];then
    if [[ -z "$(cat $HOME/.profile|grep $bin)" ]];then
        echo -e "\n\n$cmd\n" >> $HOME/.profile
    fi
fi
