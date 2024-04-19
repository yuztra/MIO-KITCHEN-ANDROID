cd $TOOLKIT
chmod -R 777 $TOOLKIT
if [[ ! -f b_i ]]; then
   for applet in $(./busybox --list); do
        case "$applet" in
        "tune2fs"|"mke2fs")
        exit 0
        ;;
        *)
         ./busybox ln -sf busybox "$applet";
         echo > b_i
        ;;
        esac
   done
fi