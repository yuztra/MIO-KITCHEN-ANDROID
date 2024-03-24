start(){
chmod -R 777 $bin/*
cd $TOOLKIT
if [[ ! -f b_i ]]; then
   for applet in $(./busybox --list); do
        case "$applet" in
        "tune2fs"|"mke2fs")
            echo "ソフトリンク $applet の作成をスキップ"
        ;;
        *)
        echo "ソフトリンク $applet　を作成"
            ./busybox ln -sf busybox "$applet";
            echo > b_i
        ;;
        esac
   done
fi
}
start