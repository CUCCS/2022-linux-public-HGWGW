#!/usr/bin/env bash
function help {
    echo "doc"
    echo "-a    统计不同年龄区间范围(20岁以下、[20-30]、30岁以上)的球员数量、百分比"
    echo "-p    统计不同场上位置的球员数量、百分比"
    echo "-n    名字最长的球员是谁？名字最短的球员是谁？"
    echo "-m    年龄最大的球员是谁？年龄最小的球员是谁？"
    echo "-h    帮助文档"
}

# 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
function Age {
    awk -F "\t" '
        BEGIN {a=0; b=0; c=0;}
        $6!="Age" {
            if($6>=0 && $6<20) {
                a++;
            }
            else if($6<=30){
                b++;
            }
            else{
                c++;
            }
        }
        END {
            sum=a+b+c;
            printf("Age\tCount\tPercentage\n");
            printf("<20\t%d\t%f%%\n",a,a*100.0/sum);
            printf("[20,30]\t%d\t%f%%\n",b,b*100.0/sum);
            printf(">30\t%d\t%f%%\n",c,c*100.0/sum);
        }' worldcupplayerinfo.tsv
}

# 统计不同场上位置的球员数量、百分比
function Position {
    awk -F "\t" '
        BEGIN {sum=0;}
        $5!="Position" {
            pos[$5]++;
            sum++;
        }
        END {
            printf("Position\tCount\tPercentage\n");
            for(i in pos) {
                printf("%-10s\t%d\t%f%%\n",i,pos[i],pos[i]*100.0/sum);
            }
        }' worldcupplayerinfo.tsv
}

# 名字最长的球员是谁？名字最短的球员是谁？
function Name {
    awk -F "\t" '
        BEGIN {max=-1;min=1000;}
        $9!="Player" {
            len=length($9);
            name[$9]=len;
            max=len>max?len:max;
            min=len<min?len:min;
        }
        END {
            for(i in name) {
                if(name[i]==max){
                    printf("The player with the longest name is %s\n",i);
                }
                else if(name[i]==min){
                    printf("The player with the shortest name is %s\n",i);
                }
            }
        }' worldcupplayerinfo.tsv
}

# 年龄最大的球员是谁？年龄最小的球员是谁？
function MaxMin {
    awk -F "\t" '
        BEGIN {max=-1;min=1000;}
        $6!="Age" {
            age=$6;
            name[$9]=age;
            max=age>max?age:max;
            min=age<min?age:min;
        }
        END {
            for(i in name){
                if(name[i]==max){
                    printf("The oldest player is %s,his age is %d\n",i,max);
                }
                else if(name[i]==min){
                    printf("The youngest player is %s,his age is %d\n",i,min);
                }
            }
        }' worldcupplayerinfo.tsv
}

while [ "$1" != "" ];do
case "$1" in
    "-a")
        Age "$2"
        exit 0
        ;;
    "-p")
        Position "$2"
        exit 0
        ;;
    "-n")
        Name "$2" 
        exit 0
        ;;
    "-m")
        MaxMin "$2"
        exit 0
        ;;
    "-h")
        help "$2"
        exit 0
        ;;
esac
done