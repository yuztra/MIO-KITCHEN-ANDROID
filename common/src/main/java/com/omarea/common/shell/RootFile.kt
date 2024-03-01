package com.omarea.common.shell

/**
 * Created by Hello on 2018/07/06.
 */

object RootFile {

    fun fileExists(path: String): Boolean {
        return KeepShellPublic.doCmdSync("if [[ -f \"$path\" ]]; then echo 1; fi;") == "1"
    }


}
