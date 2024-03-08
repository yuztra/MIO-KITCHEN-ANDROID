start(){
chmod -R 777 $bin/*
cd $TOOLKIT
if [[ ! -f b_i ]]; then
   for applet in $(./busybox --list); do
        case "$applet" in
        "tune2fs"|"mke2fs")
            echo "跳过链接$applet"
        ;;
        *)
        echo "正在链接$applet"
            ./busybox ln -sf busybox "$applet";
            echo > b_i
        ;;
        esac
   done
fi
}
start