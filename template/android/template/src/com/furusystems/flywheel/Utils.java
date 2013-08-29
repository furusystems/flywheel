package com.furusystems.flywheel;

import android.content.Context;
import android.content.res.Resources;
import android.net.Uri;
import android.content.ContentResolver;

public class Utils
{
    public static Uri buildResourceUri(Context context, int id){
        Resources resources = context.getResources();
        return Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + resources.getResourcePackageName(id) + '/' + resources.getResourceTypeName(id) + '/' + resources.getResourceEntryName(id) );
    }
}
	