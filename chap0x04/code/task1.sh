#!/usr/bin/env bash
function help {
    echo "doc"
    echo "-q Q                      对jpeg格式图片进行图片质量因子为Q的压缩"
    echo "-r R                      对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩成R分辨率"
    echo "-w font_size text         对图片批量添加自定义文本水印"
    echo "-p text                   统一添加文件名前缀，不影响原始文件扩展名"
    echo "-s text                   统一添加文件名后缀，不影响原始文件扩展名"
    echo "-t                        将png/svg图片统一转换为jpg格式图片"
    echo "-h                        帮助文档"
}

# 对jpeg格式图片进行图片质量压缩
# 方法一：convert filename1 -quality 50 filename2
function compressQuality {
    Q=$1 #获取质量因子
    for i in *;do
        type=${i##*.} #删除最后一个.及左边全部字符，获取文件后缀
        if [[ ${type} != "jpeg" ]];then continue;fi;
        convert "${i}" -quality "${Q}" "${i}"
        echo "${i} is compressed."
    done
}

# 方法二：直接用convert -resize压缩成100x100的图片
# function compressQuality {
#     convert -resize 100x100 a.jpeg  a-1.jpeg
#     echo "a.jpeg已被压缩为a-1.jpeg"
# }

# compressQuality #调用函数

# 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
# convert filename1 -resize R filename2
function compressResolusion {
    R=$1 #获取压缩分辨率
    for i in *;do
        type=${i##*.} #删除最后一个.及左边全部字符，获取文件后缀
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]];then continue;fi
        convert "${i}" -resize "${R}" "${i}"
        echo "${i} is resized."
    done
}

# 支持对图片批量添加自定义文本水印
# convert filename1 -pointsize 50 -fill green -gravity northeast -draw "text 10,10 'hgwgw'" filename2
function watermark {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]];then continue;fi
        convert "${i}" -pointsize "$1" -fill green -gravity northeast -draw "text 10,10 '$2'" "${i}"
        echo "${i} is watermarked with $2."
    done
}

# 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
# mv filename1 filename2
function prefix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        mv "${i}" "$1""${i}"
        echo "${i} is renamed to $1${i}"
    done
}
function suffix {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        filename=${i%.*}$1"."${type}
        mv "${i}" "${filename}"
        echo "${i} is renamed to ${filename}"
    done
}

# 支持将png/svg图片统一转换为jpg格式图片
# convert xxx.png xxx.jpg
function transform2Jpg {
    for i in *;do
        type=${i##*.}
        if [[ ${type} != "jpeg" && ${type} != "png" && ${type} != "svg" ]]; then continue; fi;
        new_file=${i%%.*}".jpg"
        convert "${i}" "${new_file}"
        echo "${i} is transformed to jpg"
    done
}


while [ "$1" != "" ];do
case "$1" in
    "-q")
        compressQuality "$2"
        exit 0
        ;;
    "-r")
        compressResolusion "$2"
        exit 0
        ;;
    "-w")
        watermark "$2" "$3"
        exit 0
        ;;
    "-p")
        prefix "$2"
        exit 0
        ;;
    "-s")
        suffix "$2"
        exit 0
        ;;
    "-t")
        transform2Jpg
        exit 0
        ;;
    "-h")
        help "$2"
        exit 0
        ;;
esac
done
