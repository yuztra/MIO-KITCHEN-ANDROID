package com.omarea.common.shared

import com.omarea.common.shell.KeepShellPublic

class RootFileInfo {

    var parentDir: String = ""
    var filePath: String = ""
    var isDirectory: Boolean = false
    var fileSize: Long = 0
    private fun itemExists(path: String): Boolean {
        return KeepShellPublic.doCmdSync("if [[ -e \"$path\" ]]; then echo 1; fi;") == "1"
    }
    private val fileName: String
        get() {
            if (filePath.endsWith("/")) {
                return filePath.substring(0, filePath.length - 1)
            }
            return filePath
        }

    private val absolutePath: String
        get() = "$parentDir/$fileName"


    fun exists(): Boolean {
        return itemExists(this.absolutePath)
    }

    fun length(): Long {
        return this.fileSize
    }
}
