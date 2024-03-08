#新建项目
[ -e ${XBJ} ] && xm=`cat ${XBJ}`
[ ! -d $mdir/$xm ]&&mkdir -p $mdir/$xm
yy (){
echo "长风破浪会有时，直挂云帆济沧海"
}
packzip(){
echo "开始打包ROM:${name}.zip"
[ -z $lj ]&&error "请输入路径，打包"
[ -x $name ]&&error "请输入名称，打包"
if [ "$kxyt" == "1" ] && [ ! -z "$code" ]; then
utils kxyt ${lj}/ $bin/extra_flash.zip $code
else
[ -z "$code" ] && warn "请输入机型代号"
fi
7z a -tzip ${lj}/${name}.zip $zml/$xm/*
if [ $? = 0 ];then
echo "打包完成，输出${lj}/${name}.zip"
else
warn "打包失败"
[ -f ${lj}/${name}.zip ]&&rm -rf ${lj}/${name}.zip
fi
}
dg (){
[ -f $zml/$xm/super.img ]&&echo "super.img"
[ -f $zml/$xm/payload.bin ]&&echo "payload.bin"
}
readdt(){
if [ -e $zml/$xm/super.img ];then
utils lpdump $zml/$xm/super.img
fi
if [ -e $zml/$xm/payload.bin ];then
payload -l $zml/$xm/payload.bin
fi
}
extract_part(){
Extract=$zml/image
IFS=$'\n'
[[ ! -d "$Extract" ]] && mkdir -p "$Extract"

for i in ${IMG}; do
    e=${i##*/}
    File="$Extract/${e}.img"
    [[ ! -L ${i} ]] && echo "！$e分区不存在无法提取"
    echo "- 开始提取$e分区"
    dd if="${i}" of="$File"
    echo "- 已提取$e分区到：$File"
    echo
done
}
parts (){
if [[ 0 ]]; then
a=0
b=(`ls /dev/block/`)
    for i in ${b[@]}; do
        [[ -d /dev/block/${i} ]] && unset b[$a]
        a=$((a+1))
    done
        BLOCKDEV=`which blockdev`
    
            find /dev/block -type l | while read o; do
                [[ -d "$o" ]] && continue
                c=`basename "$o"`
                echo ${b[@]} | grep -q "$c" && continue
                echo $c
            done | sort -u | while read Row; do
                BLOCK=`find /dev/block/by-name -name $Row | head -n 1`
                    if [[ -n $BLOCKDEV ]]; then   
                        size=`blockdev --getsize64 $BLOCK`
                        if [[ $size -ge 1073741824 ]]; then
                            File_Type=`awk "BEGIN{print $size/1073741824}"`G
                        elif [[ $size -ge 1048576 ]]; then
                            File_Type=`awk "BEGIN{print $size/1048576}"`MB
                        elif [[ $size -ge 1024 ]]; then
                            File_Type=`awk "BEGIN{print $size/1024}"`kb
                        elif [[ $size -le 1024 ]]; then
                            File_Type=${size}b
                        fi
                       [ "$File_Type" != "b" ]&&echo "$BLOCK|$Row 「大小：$File_Type」" 
                    else
                        echo "$BLOCK|$Row" 
                    fi
            done
fi
}
tqdgjx(){
if [ -f $zml/$xm/super.img ];then
[ "$(utils utils gettype $zml/$xm/super.img)" = "sparse" ]&&str $zml/$xm/super.img
fi

if [ $qptq = 1 ];then
if [ "$tqjx" = "super.img" ];then
echo "正在提取[super]:super.img"
utils lpunpack $zml/$xm/super.img $zml/$xm/
errorlevel=$?
if [ $? = 0 ] && [ $del = 1 ];then
rm -rf $zml/$xm/super.img
else
[ $errorlevel = 1 ]&&warn "解包super时异常"
fi
fi
if [ "$tqjx" = "payload.bin" ];then
echo "正在解包[payload]:payload.bin"
payload -o $zml/$xm/ $zml/$xm/payload.bin
if [ $? = 0 ] && [ $del = 1 ];then
rm -rf $zml/$xm/$tqjx
fi
fi
exit 0
fi
for i in ${jxs}
do
echo "正在提取$i"
[ "$tqjx" = "super.img" ]&&utils lpunpack $zml/$xm/super.img $zml/$xm/ ${i} 1
[ "$tqjx" = "payload.bin" ]&&payload -output $zml/$xm/ -partitions $i $zml/$xm/payload.bin
done
[ $del = 1 ]&&rm -rf $zml/$xm/$tqjx
for i in $(ls *_a.img)
do
echo "重命名$i到$(echo $i|sed 's/_a//g')"
mv $i $(echo $i|sed 's/_a//g')
done
}
cm (){
for i in $(ls -d $START_DIR/module/*/ )
do
basename $i
done
}
flash_img (){
[[ -z ${iMG} ]] && error "刷入"
IFS=$'\n'
e=${IMG##*/}
echo "- 您当前选择了$e分区"
echo "- 刷入文件路径：$Brush_in"
echo "- 检测刷入镜像文件是否存在"
[[ ! -L "${i}MG" ]] && abort "！$e分区不存在无法刷入"
    if [[ -f "$Brush_in" ]]; then
        echo "- 开始刷写$e分区"
        dd if="$Brush_in" of="${i}MG"
        if [[ $CQ = 1 ]]; then
         echo "即将重启到恢复模式，倒计时开始……"
         for i in $(seq 4 -1 1); do
            echo ${i}
            sleep 1
         done
         reboot recovery
         fi
         if [[ $CQ1 = 1 ]]; then
          echo "即将重启手机，倒计时开始……"
          for i in $(seq 4 -1 1); do
            echo ${i}
            sleep 1
          done
          reboot
         fi
    else
        error "！$Brush_in刷入文件不存在无法刷写到$e分区，操作"
    fi
    echo "- 完成"
    sleep 2
}
gszh(){
for i in ${IMG}
do
if [ $gs = sparse ];then
if [ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "erofs" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "super" ] ;then
rts $zml/$xm/${i}.img
fi
[ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ]&&warn "${i}已是sparse格式"
fi
if [ $gs = raw ];then
if [ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "erofs" ] || [ "$(utils gettype $zml/$xm/${i}.img)" = "super" ] ;then
warn "$i已经为raw镜像"
fi
[ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ]&&rts $zml/$xm/${i}.img
fi
if [ $gs = dat ]||[ $gs = br ];then
[ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ]&&rts $zml/$xm/${i}.img
if [ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ];then
echo "[img]到[dat]:${i}.img"
utils img2sdat $zml/$xm/${i}.img $zml/$xm/ 4 ${i}
if [ -f $zml/$xm/${i}.new.dat ];then
[ $del = 1 ]&&rm -rf $zml/$xm/${i}.img
fi
fi
if [ $gs = br ];then
echo "[dat]到[br]:${i}.new.dat"
brotli -q $brlv -j -w 24 $zml/$xm/${i}.new.dat -o $zml/$xm/${i}.new.dat.br
if [ -f $zml/$xm/${i}.new.dat.br ];then
[ $del = 1 ]&&rm -rf $zml/$xm/${i}.new.dat
fi
fi
fi
done
}
warn () {
echo "$1" >&2
}
download (){
if [ -z $romdz ];then
warn 请输入有效内容
exit 1
fi
rname=$(basename $romdz)
if [ -e $zml/${rname%?*} ];then
warn "您似乎已经下载了这个文件"
echo "要重新下载吗"
if pd;then
rm -rf $zml/${rname%?*}
else
echo "跳过"
[ $jb = 0 ]&&exit 0
fi
if [ $jb = 1 ];then
echo "要解包这个文件吗"
if pd;then
xzrom=$zml/${rname%?*}
UZ
else
echo "跳过解包"
exit 0
fi
fi
fi
echo "已开启最大速率"
curl -# -L -k $romdz -o $zml/${rname%?*}
if [ $? = 1 ];then
error "下载失败"
rm -rf $zml/${rname%?*}
fi
if [ $? = 0 ]&&[ $jb = 1 ];then
xzrom=$zml/${rname%?*}
UZ
fi
}
error (){
echo "$1失败，请截图联系寒风居士">&2
exit 1
}
make_ext4 (){
[ ${img_type} = sparse ] && argv=-s
make_ext4fs -J -T 1 $argv -S $con -l $size -C $fs -L $1 -a $1 $zml/$xm/$1.img $mdir/$xm/$1
[ $? = 1 ]&&error 打包
if [ $jxys = 1 ];then
if [ ${i}mg_type = raw ];then
resize2fs -M $zml/$xm/$1.img
else
warn 您已打包为sparse，无法压缩
fi
fi
}
mkeimg (){
	size2=`echo $size/4096|bc|cut -d "." -f 1`
	bin/mke2fs -O ^has_journal -t ext4 -b 4096 -L $1 -I 256 -M /$1 $zml/$xm/$1.img $size2
	[ "$Reading" = "ro" ] && dx=-s
	bin/e2fsdroid -e -T 1230768000 -C $fs -S $con -f $mdir/$xm/$1 -a /$1 $dx $zml/$xm/$1.img
  if [ $? = 1 ];then
  error 打包
  rm -rf $zml/$xm/$1.img
  fi
  [ $jxys = 1 ]&&resize2fs -M $zml/$xm/$1.img
  [ ${i}mg_type = sparse ] && rts $zml/$xm/$1.img
}
packsuper (){
if [ "$type" = "A" ];then
command+="--metadata-size 65536 -super-name super -metadata-slots 2 -device super:${super_size} --group ${super_group}:${super_size} "
fi
for i in ${simg}
do
[ "$(utils gettype $zml/$xm/${i}.img)" = "sparse" ]&&str $zml/$xm/${i}.img
if [ "$(utils gettype $zml/$xm/${i}.img)" = "erofs" ]||[ "$(utils gettype $zml/$xm/${i}.img)" = "ext" ];then
[ "$type" = "A" ]&&command+="--partition ${i}:readonly:$(wc -c <$zml/$xm/${i}.img):${super_group} --image ${i}=$zml/$xm/${i}.img "
if [ "$type" = "AB" ]||[ "$type" = "VAB" ];then
ml1+="--partition ${i}_a:readonly:$(wc -c <$zml/$xm/${i}.img):${super_group}_a --image ${i}_a=$zml/$xm/${i}.img "
ml2+="--partition ${i}_b:readonly:0:${super_group}_b "
fi
fi
done
if [ "$type" = "AB" ]||[ "$type" = "VAB" ];then
command+="--metadata-size 65536 -super-name super -metadata-slots 3 -device super:${super_size} --group ${super_group}_a:${super_size} ${ml1} --group ${super_group}_b:${super_size} ${ml2} "
fi
[ "$type" = "VAB" ]&&command+="--virtual-ab "
[ "$from" = "sparse" ]&&command+="--sparse "
lpmake $command --out $zml/$xm/super.img
if [ $? = 0 ];then
echo " - 打包成功！"
else
error " - 打包super"
fi
}
findfile (){
for i in $(ls $zml/$xm/*.$1)
do
basename ${i} .$1
done
}
readsize (){
if [ -f $zml/$xm/dynamic_partitions_op_list ];then
list=$zml/$xm/dynamic_partitions_op_list
else
list=/dev/null
fi
if [ "$psize" = "auto" ];then
size=$(utils rsize $mdir/$xm/${1} 1 $list)
else
if [ -e $mdir/$xm/config/${1}_size.txt ]; then
size=$(cat $mdir/$xm/config/${1}_size.txt)
else
warn "镜像大小配置不存在，切换为动态读取"
size=$(utils rsize $mdir/$xm/${1} 1 $list)
fi
size=$(utils rsize $mdir/$xm/${1} 1 $list)
fi
}
mkerofs (){
	mkfs.erofs -z${type},${fze} -T 1230768000 --mount-point=/$1 --fs-config-file=$fs --file-contexts=$con $zml/$xm/${i}.img $mdir/$xm/${i}
}
pack(){
for i in ${UIMGS};do
xmdz=`cat ${XBJ}`
fs=$mdir/$xm/config/"${i}"_fs_config
con=$mdir/$xm/config/"${i}"_file_contexts
utils patch_fs_con $mdir/$xm/${i} $fs $con
echo " - 正在打包${i}"
readsize "${i}"
if [ ! -f $mdir/$xm/config/${i}_erofs ];then
if [ "$zhua" != "1" ];then
$dbfs "${i}"
else
mkerofs "${i}"
fi
else
if [ "$zhua" != "1" ];then
mkerofs "${i}"
else
$dbfs "${i}"
fi
fi
if [ -f $zml/$xm/${i}.img ];then
echo " - 打包${i}完成"
[ $del = 1 ]&&rm -rf $mdir/$xm/$i
else
[ $? = 1 ]&&warn "打包失败，不删除源文件"
fi
done
}
rts (){
echo "[raw]到[sparse]:$(basename $1)"
img2simg $1 $1_sparse
[ -e "$1"_sparse ] && rm -rf $1
mv "$1"_sparse $1
}
str (){
echo "[sparse]到[raw]：$(basename $1)"
simg2img "$1" "$1"_raw
[ -e "$1"_raw ] && rm -rf $1
mv "$1"_raw $1
}
mn () {
if [ -d $zml/"$xmmc" -o -d $mdir/"$xmmc" ]; then
  echo "- 项目已存在，将自动重命名！"
  xmmc="$xmmc"-`date "+%Y%m%d%H%M%S"`
  echo "- 正在创建：${xmmc}"
  mkdir -p $zml/"$xmmc"
  mkdir -p $mdir/"$xmmc"
else
  echo "- 正在创建：${xmmc}"
  mkdir -p $zml/"$xmmc"
  mkdir -p $mdir/"$xmmc"
fi
echo "- 创建完成！"
echo ${xmmc} > ${XBJ}
}
pd (){
if [ $(id -u ) = 0 ];then
echo "音量键选择"
else
warn "您正在使用非Root模式，默认选择否"
return 1
exit 0
fi
echo "[+]是 [-]否"
key=$(getevent -qlc 1)
Up=$(echo $key |grep KEY_VOLUMEUP)
Down=$(echo $key |grep KEY_VOLUMEDOWN)
	[ "$Up" != "" ] && return 0
	[ "$Down" != "" ] && return 1
}
install_module (){
mkdir -p $START_DIR/module
7z x -y $file -o$START_DIR/module
chmod -R 755 $START_DIR/module/
for var in $(find $START_DIR/module/ -name install.sh);do
source $var
rm -rf $var
done
}
finddir () {
for i in $(ls -d $2/*/)
do
basename ${i}
done
}
#查看项目
check () {
for i in $(ls -d $zml/*/);do
basename ${i}
done
}
lsmdir () {
for imgs in $(ls -d $mdir/$xm/*/);do
[ -e $mdir/$xm/config/$(basename ${imgs})_file_contexts ] && basename ${imgs}
done
}
zy () {
if [ ! -d $zml/$xm ] || [ -z $xm ];then
echo "请选择一个正确的项目"
else
echo "当前选择：$xm"
fi
}
unlock (){
if [ ! -d $zml/$xm ] || [ -z $xm ];then
echo "请重新选择项目"
else
echo 'unlocked'
fi
}
#删除项目
del () {
for i in ${xms};do
echo "- 正在删除：${i}"
rm -rf $zml/${i}
rm -rf $mdir/${i}
echo "- 删除${i}完成"
done
}
UZ (){
name=$(basename "$xzrom" .zip)
if [ -d $zml/$name -o -d $mdir/$name ]; then
name="$name"-`date "+%Y%m%d%H%M%S"`
mkdir -p $zml/$name
mkdir -p $mdir/$name
else
mkdir -p $zml/$name
mkdir -p $mdir/$name
fi
echo "- 开始解包$xzrom"
7z x "$xzrom" -o$zml/$name
echo "- 完成"
echo $name > ${XBJ}
[ $del = 1 ]&&rm -rf "$xzrom"
}
ubdi (){
if [ -f "$1".new.dat.br ];then
echo " - 正在解包："$1".new.dat.br"
brotli -dj "$1".new.dat.br
rm -rf "$1".new.dat.br
fi
if [ -e "$1".new.dat.1 ];then
    echo " - 正在合并 $1"
    cat $zml/$xm/"$1".new.dat.{1..99} 2>/dev/null >> $zml/$xm/${1}.new.dat
    rm -rf $zml/$xm/${1}.new.dat.{1..99}
fi
if [  -f "$1".new.dat ];then
echo " - 正在解包："$1".new.dat"
utils sdat2img "$1".transfer.list "$1".new.dat "$1".img
rm -rf "$1".transfer.list "$1".new.dat "$1".patch.dat
fi
if [ -f ${i}.img ];then
if [[ $(utils gettype "$1".img) = sparse ]]; then
str "$1".img
fi
if [[ $(utils gettype "$1".img) = ext ]]; then
echo " - 正在解包[IMG]："$1".img"
utils extract_ext $mdir/"$xm"/ $zml/$xm/"$1".img
fi
if [[ $(utils gettype "$1".img) = erofs ]]; then
echo " - 正在解包[EROFS]：${1}.img"
extract.erofs -i $zml/$xm/"$1".img -o $mdir/$xm/ -x
echo "erofs" > $mdir/$xm/config/${1}_erofs
fi
[ -d $mdir/$xm/"$1" ] && rm -rf "$1".img
fi
}
UN (){
project=$zml/$xm/
cd $project
for i in $(ls *.*|cut -d "." -f 1);
	do
ubdi ${i}
done
exit 0
}
delmod (){
for i in ${mod}
do
echo "正在移除${i}"
[ -f $START_DIR/module/${i}/uninstall.sh ]&&source $START_DIR/module/${i}/uninstall.sh
rm -rf $START_DIR/module/${i}
if [ "$?" == "0" ];then
echo "已删除${i}"
else
echo "删除${i}失败"
fi
done
}
module (){
cat <<Mod
<?xml version="1.0" encoding="utf-8"?>
<group reload="true">
    <action reload="true" auto-off="true">
        <title>删除插件</title>
        <set>script/tool.sh delmod</set>
        <param name="mod" title="请选择插件支持多选：" options-sh="script/tool.sh cm" desc="识别已安装的插件" required="true" multiple="true"/>
    </action>
</group>
<group title="已安装的插件">
Mod
for var in $(find $START_DIR/module/ -name index.xml);do
cat $var
done

cat <<Mod
</group>
Mod
}
zdyfj (){
cd $zml/$xm/
for i in ${zdy}
do
ubdi ${i}
done
}
if (type $1 >/dev/null 2>&1);then
$1
else
findfile $1
fi