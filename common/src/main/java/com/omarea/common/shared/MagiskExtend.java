package com.omarea.common.shared;

import android.content.Context;

import com.omarea.common.shell.KeepShellPublic;
import com.omarea.common.shell.RootFile;

import java.io.File;

public class MagiskExtend {
    // source /data/adb/util_functions.sh

    public static String MAGISK_PATH = "/sbin/.core/img/scene_systemless/";
    private static String MAGISK_PATH_19 = "/data/adb/modules"; //  "/sbin/.magisk/modules";
    private static String MAGISK_ROOT_PATH1 = "/sbin/.core/img";
    private static String MAGISK_ROOT_PATH2 = "/sbin/.magisk/img";

    private static String MAGISK_MODULE_NAME = "scene_systemless";
    //magisk 19 /data/adb/modules
    private static int supported = -1;
    private static int MagiskVersion = 0;

    // 递归方式 计算文件的大小
    private static long getTotalSizeOfFilesInDir(final File file) {
        if (file.isFile())
            return file.length();
        final File[] children = file.listFiles();
        long total = 0;
        if (children != null)
            for (final File child : children)
                total += getTotalSizeOfFilesInDir(child);
        return total;
    }

    /**
     * 自动调整镜像大小
     *
     * @param require
     */
    private static boolean spaceValidation(long require) {
        // magisk 19开始，不用镜像了，理论上空间无限
        if (MagiskVersion >= 19 || MAGISK_PATH.startsWith("/data")) {
            return true;
        }

        long space = new File(MAGISK_PATH).getFreeSpace();
        // 镜像空间不足
        return space >= (require + 4096);
    }

    public static void magiskModuleInstall(Context context) {
        String moduleProp = "id=scene_systemless\n" +
                "name=Scene的附加模块\n" +
                "version=v1\n" +
                "versionCode=1\n" +
                "author=嘟嘟ski\n" +
                "description=Scene提供的Magisk拓展模块，从而在不修改系统文件的情况下，更改一些参数\n" +
                "minMagisk=17000\n";
        String systemProp = "# This file will be read by resetprop\n" +
                "# 示例: 更改 dpi\n" +
                "# ro.sf.lcd_density=410\n" +
                "# vendor.display.lcd_density=410\n";
        String service = "#!/system/bin/sh\n" +
                "# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...\n" +
                "# 这将使您的脚本兼容，即使Magisk以后改变挂载点\n" +
                "MODDIR=${0%/*}\n" +
                "\n" +
                "# 该脚本将在设备开机后作为延迟服务启动\n" +
                "\n" +
                "# 下面，你也可以添加一些自己的代码" +
                "\n";
        String fsPostData = "#!/system/bin/sh\n" +
                "# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...\n" +
                "# 这将使您的脚本兼容，即使Magisk以后改变挂载点\n" +
                "MODDIR=${0%/*}\n" +
                "\n" +
                "# 此脚本将在post-fs-data模式下执行\n";

        if (MagiskVersion < 19) {
            if (!RootFile.INSTANCE.fileExists("/data/adb/magisk.img")) {
                KeepShellPublic.INSTANCE.doCmdSync("imgtool create /data/adb/magisk.img 64");
            }
            if (!RootFile.INSTANCE.fileExists("/data/adb/magisk_merge.img")) {
                KeepShellPublic.INSTANCE.doCmdSync("imgtool create /data/adb/magisk_merge.img 128");
            }

            KeepShellPublic.INSTANCE.doCmdSync("mkdir -p /data/adb/magisk_merge_tmnt\n" +
                    "$LOOP=`imgtool mount /data/adb/magisk_merge.img /data/adb/magisk_merge_tmnt`\n");

            // 写入 模块_update 目录
            writeModuleFile(moduleProp, "module.prop", context);
            writeModuleFile("", "auto_mount", context);
            writeModuleFile("", "update", context);

            MAGISK_PATH = "/data/adb/magisk_merge_tmnt/scene_systemless/";
            writeModuleFile("", "auto_mount", context);
        } else {
            writeModuleFile("", "update", context);
        }

        // 写入模块目录
        writeModuleFile(moduleProp, "module.prop", context);
        writeModuleFile(systemProp, "system.prop", context);
        writeModuleFile(service, "service.sh", context);
        writeModuleFile(fsPostData, "post-fs-data.sh", context);
        // KeepShellPublic.INSTANCE.doCmdSync("imgtool umount /data/adb/magisk_merge_tmnt $LOOP");
    }

    private static void writeModuleFile(String text, String name, Context context) {
        if (!moduleInstalled()) {
            KeepShellPublic.INSTANCE.doCmdSync("mkdir -p " + MAGISK_PATH);
        }
        if (FileWrite.INSTANCE.writePrivateFile(text.getBytes(), name, context)) {
            String path = FileWrite.INSTANCE.getPrivateFilePath(context, name);
            String output = MAGISK_PATH + name;
            KeepShellPublic.INSTANCE.doCmdSync("cp " + path + " " + output + "\nchmod 777 " + output);
            File cache = new File(path);
            if (cache.exists()) {
                cache.delete();
            }
        }
    }

    /**
     * 是否已经安装magisk并且版本合适
     *
     * @return 是否已安装
     */
    public static boolean magiskSupported() {
        if (supported == -1 || MagiskVersion < 1) {
            String magiskVersion = KeepShellPublic.INSTANCE.doCmdSync("magisk -V");
            if (!magiskVersion.equals("error")) {
                try {
                    MagiskVersion = Integer.parseInt(magiskVersion) / 1000;
                    supported = MagiskVersion >= 17 ? 1 : 0;

                    if (supported == 1) {
                        if (MagiskVersion >= 19) {
                            MAGISK_PATH = MAGISK_PATH_19 + "/" + MAGISK_MODULE_NAME + "/";
                        } else if (RootFile.INSTANCE.dirExists(MAGISK_ROOT_PATH1)) {
                            MAGISK_PATH = MAGISK_ROOT_PATH1 + "/" + MAGISK_MODULE_NAME + "/";
                        } else if (RootFile.INSTANCE.dirExists(MAGISK_ROOT_PATH2)) {
                            MAGISK_PATH = MAGISK_ROOT_PATH2 + "/" + MAGISK_MODULE_NAME + "/";
                        }
                    }
                } catch (Exception ignored) {
                }
            } else {
                supported = 0;
            }
        }
        return supported == 1;
    }

    /**
     * 是否已安装模块
     *
     * @return
     */
    public static boolean moduleInstalled() {
        return magiskSupported() && RootFile.INSTANCE.fileExists(MAGISK_PATH + "module.prop");
    }

    public static String getMagiskReplaceFilePath(String systemPath) {
        return MAGISK_PATH.substring(0, MAGISK_PATH.length() - 1) + ((systemPath.startsWith("/vendor") || systemPath.startsWith("/product")) ? ("/system" + systemPath) : systemPath);
    }

    public static boolean replaceSystemDir(String orginPath, String newfile) {
        if (spaceValidation(getTotalSizeOfFilesInDir(new File(newfile)))) {
            if (RootFile.INSTANCE.itemExists(newfile)) {
                String output = getMagiskReplaceFilePath(orginPath);
                String dir = new File(output).getParent();
                KeepShellPublic.INSTANCE.doCmdSync("mkdir -p \"" + dir + "\"\n" + "cp -a \"" + newfile + "\" \"" + output + "\"\n" +
                        "chmod -R 777 \"" + output + "\"");
                return true;
            }
        }
        return false;
    }

    public static boolean updateServiceSH(String fromFile) {
        return updateFile(fromFile);
    }

    private static boolean updateFile(String fromFile) {
        if (spaceValidation(getTotalSizeOfFilesInDir(new File(fromFile)))) {
            if (RootFile.INSTANCE.fileExists(fromFile)) {
                KeepShellPublic.INSTANCE.doCmdSync("cp \"" + fromFile + "\" " + MAGISK_PATH + "service.sh" + "\nchmod 777 " + MAGISK_PATH + "service.sh");
            }
            return true;
        }
        return false;
    }
}
