package com.furusystems.flywheel;

import org.haxe.lime.GameActivity;
import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Looper;
import android.util.Log;

import android.content.res.Resources;
import android.content.ContentResolver;
import android.view.ViewGroup;
import android.widget.VideoView;


public class FlywheelVideo implements MediaPlayer.OnCompletionListener
{
    static final String TAG = "FlywheelVideo";
	private static FlywheelVideo instance;
	private VideoView video;
	
	public FlywheelVideo()
    {
    	instance = this;
        Looper.prepare();
    }

    public void destroyVideoView(){
       if(video!=null){
            video.stopPlayback();
            video.setOnCompletionListener(null);
            video = null;
            GameActivity.popView();
        }
    }
    public VideoView createVideoView(String resourcePath) {
        if(video==null){
            Log.i(TAG, "Creating video view");
            video = new VideoView(GameActivity.getContext());
            video.setOnCompletionListener(this);
            Log.i(TAG, "Setting...");
			try{
				GameActivity.pushView(video);
			}catch(Exception e){
				Log.e(TAG,"Ruh roh");
			}
            Log.i(TAG, "Video view set as current");
        }else{
            video.stopPlayback();
        }
        Log.i(TAG, "Setting video uri");
        video.setVideoURI(Utils.buildResourceUri(GameActivity.getContext(), GameActivity.getResourceID(resourcePath)));
        return video;
    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        destroyVideoView();
    }

    public static void initialize(){
        new FlywheelVideo();
    }

    public static void release(){
        instance.destroyVideoView();
    }

	public static void playVideo(String resourcePath)
	{
        Log.i(TAG, resourcePath);
        instance.createVideoView(resourcePath);
	}

    public static void stopVideo(){
        instance.destroyVideoView();
    }
}
	