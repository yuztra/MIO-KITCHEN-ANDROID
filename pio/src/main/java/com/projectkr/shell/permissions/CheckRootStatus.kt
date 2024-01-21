package com.projectkr.shell.permissions

import android.app.AlertDialog
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.omarea.common.shell.KeepShellPublic
import com.omarea.common.ui.DialogHelper
import com.projectkr.shell.R
import kotlin.system.exitProcess

/**
 * 检查获取root权限
 * Created by helloklf on 2017/6/3.
 */

class CheckRootStatus(var context: Context, private var next: Runnable? = null) {
    private var myHandler: Handler = Handler(Looper.getMainLooper())

    private var therad: Thread? = null
    fun forceGetRoot() {
        if (lastCheckResult) {
            if (next != null) {
                myHandler.post(next)
            }
        } else {
            var completed = false
            therad = Thread {
                rootStatus = KeepShellPublic.checkRoot()
                if (completed) {
                    return@Thread
                }

                completed = true

                if (lastCheckResult) {
                    if (next != null) {
                        myHandler.post(next)
                    }
                } else {
                    myHandler.post {
                        KeepShellPublic.tryExit()
                        val builder = AlertDialog.Builder(context)
                                .setTitle(R.string.warn_)
                                .setIcon(R.drawable.info)
                                .setMessage(R.string.error_root)
                                .setPositiveButton(R.string.btn_retry) { _, _ ->
                                    KeepShellPublic.tryExit()
                                    if (therad != null && therad!!.isAlive && !therad!!.isInterrupted) {
                                        therad!!.interrupt()
                                        therad = null
                                    }
                                    forceGetRoot()
                                }
                                .setNegativeButton(R.string.btn_exit) { _, _ -> exitProcess(0)}

                        if (!context.resources.getBoolean(R.bool.force_root)) {
                            builder.setNeutralButton(R.string.btn_skip) { _, _ ->
                                if (next != null) {
                                    myHandler.post(next)
                                }
                            }
                        }
                        DialogHelper.animDialog(builder).setCancelable(false)
                    }
                }
            }
            therad!!.start()
            Thread(Runnable {
                Thread.sleep(1000 * 15)

                if (!completed) {
                    KeepShellPublic.tryExit()
                    myHandler.post {
                        DialogHelper.confirm(context,
                        context.getString(R.string.error_root),
                        context.getString(R.string.error_su_timeout),
                        null,
                        DialogHelper.DialogButton(context.getString(R.string.btn_retry), {
                            if (therad != null && therad!!.isAlive && !therad!!.isInterrupted) {
                                therad!!.interrupt()
                                therad = null
                            }
                            forceGetRoot()
                        }),
                        DialogHelper.DialogButton(context.getString(R.string.btn_exit), {
                            exitProcess(0)
                        }))
                    }
                }
            }).start()
        }
    }

    companion object {
        private var rootStatus = false

        // 最后的ROOT检测结果
        val lastCheckResult: Boolean
            get() {
                return rootStatus
            }
    }
}
