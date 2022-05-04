#!/usr/bin/env bash
function help {
    echo "doc"
    echo "-o        统计访问来源主机TOP 100和分别对应出现的总次数"
    echo "-i        统计访问来源主机TOP 100 IP和分别对应出现的总次数"
    echo "-u        统计最频繁被访问的URL TOP 100"
    echo "-r        统计不同响应状态码的出现次数和对应百分比"
    echo "-f        分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
    echo "-s URL    给定URL输出TOP 100访问来源主机"
    echo "-h        帮助文档"
}

# 统计访问来源主机TOP 100和分别对应出现的总次数
function top100_host {
    printf "%40s\t%s\n" "top100_host" "count"
    awk -F "\t" '
    NR>1 {
        host[$1]++;
    }
    END {
        for(i in host){
            printf("%40s\t%d\n",i,host[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计访问来源主机TOP 100 IP和分别对应出现的总次数
function top100_ip {
    printf "%20s\t%s\n" "top100_ip" "count"
    awk -F "\t" '
    NR>1 {
        if(match($1,/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$/)){
            ip[$1]++;
        }
    }
    END {
        for(i in ip){
            printf("%20s\t%d\n",i,ip[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计最频繁被访问的URL TOP 100
function top100_url {
    printf "%55s\t%s\n" "top100_url" "count"
    awk -F "\t" '
    NR>1 {
        url[$5]++;
    }
    END {
        for(i in url){
            printf("%55s\t%d\n",i,url[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

# 统计不同响应状态码的出现次数和对应百分比
function response {
    awk -F "\t" '
    BEGIN {
        printf("response\tcount\tpercentage\n");
    }
    NR>1 {
        response[$6]++;
    }
    END {
        for(i in response){
            printf("%d\t%d\t%f%%\n",i,response[i],response[i]*100/(NR-1));
        }
    }' web_log.tsv
}

# 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function 4xxresponse {
    printf "%70s\t%s\n" "code=403 url" "count"
    awk -F "\t" '
    NR>1 {
        if($6==403) {
            url[$5]++;
        }
    }
    END {
        for(i in url) {
            printf("%70s\t%d\n",i,url[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100

    printf "%70s\t%s\n" "code=404 url" "count"
    awk -F "\t" '
    NR>1 {
        if($6==404) {
            url[$5]++;
        }
    }
    END {
        for(i in url) {
            printf("%70s\t%d\n",i,url[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

# 给定URL输出TOP 100访问来源主机
function top100_source {
    printf "%30s\t%10s\n" "top100_source" "count"
    awk -F "\t" '
    NR>1 {
        if("'"$1"'"==$5) {
            host[$1]++;
        }
    }
    END {
        for(i in host){
            printf("%30s\t%d\n",i,host[i]);
        }
    }' web_log.tsv | sort -g -k 2 -r | head -100
}

while [ "$1" != "" ];do
case "$1" in
    "-o")
        top100_host "$2"
        exit 0
        ;;
    "-i")
        top100_ip "$2"
        exit 0
        ;;
    "-u")
        top100_url "$2" 
        exit 0
        ;;
    "-r")
        response "$2"
        exit 0
        ;;
    "-f")
        4xxresponse "$2"
        exit 0
        ;;
    "-s")
        top100_source "$2"
        exit 0
        ;;        
    "-h")
        help "$2"
        exit 0
        ;;
esac
done


