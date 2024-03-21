start(){
chmod -R 777 $bin/*
cd $TOOLKIT
if [[ ! -f b_i ]]; then
   for applet in $(./busybox --list); do
        case "$applet" in
        "tune2fs"|"mke2fs")
            echo "Skip creating symlink for $applet"
        ;;
        *)
        echo "Creating symlink for $applet"
            ./busybox ln -sf busybox "$applet";
            echo > b_i
        ;;
        esac
   done
fi
}
start