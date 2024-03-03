package com.omarea.krscript;

import android.content.Context;
import android.os.Process;
import android.os.UserManager;

public class FileOwner {
    private final Context context;
    public FileOwner(Context context) {
        this.context = context;
    }

    public int getUserId() {
        UserManager um = (UserManager) context.getSystemService(Context.USER_SERVICE);
        android.os.UserHandle userHandle = android.os.Process.myUserHandle();
        try {
            return  (int) um.getSerialNumberForUser(userHandle);
        } catch (Exception ignored) {
            return 0;
        }
    }

    public String getFileOwner() {
        int androidUid = getUserId();
        return  "u" + androidUid + "_a" + ((android.os.Process.myUid() % 100000) - Process.FIRST_APPLICATION_UID); // 100000 => UserHandle.PER_USER_RANGE
    }
}
