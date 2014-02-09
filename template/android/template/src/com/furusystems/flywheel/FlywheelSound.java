package com.furusystems.flywheel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.IOException; 
import java.util.Hashtable;
import org.haxe.lime.GameActivity;

import android.content.Context;
import android.util.Log;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.net.Uri;

import android.content.res.Resources;
import android.content.ContentResolver;

import java.util.ArrayList;

public class FlywheelSound implements SoundPool.OnLoadCompleteListener
{
	private static Context mContext;
	private static FlywheelSound instance;

	private static Hashtable<Integer, Integer> soundPoolIndices = new Hashtable<Integer, Integer>();

	private static MediaPlayer mediaPlayer;
	private static boolean mMusicWasPlaying = false;
	private static SoundPool mSoundPool;
	private static int mSoundPoolID = 0;

	private static int mSoundPoolIndex = 0;
	private static int soundpoolPolyphony = 8;
	
	private static int loadsRequested = 0;
	private static int loadsCompleted = 0;
	
	private static AudioManager mAudioManager;
    public FlywheelSound(Context context)
    {
    	if (instance == null) {
            Log.i("Sound","Creating soundpool");
			mSoundPool = new SoundPool(soundpoolPolyphony, AudioManager.STREAM_MUSIC, 0);
			mSoundPool.setOnLoadCompleteListener(this);
			if (mSoundPoolID > 1) {
				mSoundPoolID++;
			} else {
				mSoundPoolID = 1;
			}
		}

    	instance = this;
    	mContext = context;
    	mAudioManager = (AudioManager)mContext.getSystemService(Context.AUDIO_SERVICE);
    }
    
    public static void initialize(){
    	new FlywheelSound(GameActivity.getContext());
    }
	
    public void onLoadComplete(SoundPool soundPool, int sampleId, int status){
    	Log.v("Sound", "Soundpool load complete for id "+sampleId);
		loadsCompleted++;
    	_poolReady = loadsRequested==loadsCompleted?1:0;
    	Log.v("Sound", loadsRequested+"/"+loadsCompleted);
    }
    
    public static void pauseMusic(){
		if (mediaPlayer != null) {
			mMusicWasPlaying = mediaPlayer.isPlaying ();
			mediaPlayer.pause();
		}
    }
    public static void resumeMusic(){
    	if (mediaPlayer != null && mMusicWasPlaying && !mAudioManager.isMusicActive()) {
			mediaPlayer.start ();
		}	
    }
    
	public static void pauseAll()
	{
		mSoundPool.autoPause();
		
		if (mediaPlayer != null) {
			mMusicWasPlaying = mediaPlayer.isPlaying ();
			mediaPlayer.pause();
		}
	}

	public static void resumeAll()
	{
		mSoundPool.autoResume();

		if (mediaPlayer != null && mMusicWasPlaying && !mAudioManager.isMusicActive()) {
			mediaPlayer.start ();
		}	
		
	}
	private static int _poolReady = 0;
	public static int isPoolReady(){
		return _poolReady;
	}
	/*
	 * Sound effects using SoundPool
	 *
	 * This allows for low latency and CPU load but sounds must be 100kB or smaller
	 */

	public static int getSoundHandle(String inFilename)
	{
        Log.v("Sound","Get sound handle ------" + inFilename);
		int id = GameActivity.getResourceID(inFilename);
        Log.v("Sound", "ID: "+ inFilename + " = " + id);
		if(soundPoolIndices.containsKey(id)){
			int index = soundPoolIndices.get(id);
			Log.v("Sound", "Returning existing index: "+index);
			return index;
		}

		
		if (id > 0) {
			int index = mSoundPool.load(mContext, id, 1);
			Log.v("Sound", "Loaded index: " + index);
			soundPoolIndices.put(id, index);
			loadsRequested++;
			return index;
		} else {
			int index = mSoundPool.load(inFilename, 1);
			loadsRequested++;
			return index;
		}
		
		//return -1;
    }
	
	public static int getSoundPoolID()
	{
		return mSoundPoolID;
	}

	public static int playSound(int inResourceID, double inVolLeft, double inVolRight, int inLoop, int priority, double rate)
	{
		Log.v("Sound", "PlaySound -----" + inResourceID);
		
		if (inLoop > 0) {
			inLoop--;
		}
		
		return mSoundPool.play(inResourceID, (float)inVolLeft, (float)inVolRight, priority, inLoop, (float)rate);
	}
	
	static public SoundPool getPool(){
		return mSoundPool;
	}
	
	static public void stopSound(int inStreamID)
	{
		//Log.v("Sound","Stop sound: "+inStreamID);
		if (mSoundPool != null) {
			mSoundPool.stop(inStreamID);
		}
	}
	static public void pauseSound(int id){
		if(mSoundPool != null){
			mSoundPool.pause(id);
		}
	}
	static public void resumeSound(int id){
		if(mSoundPool != null){
			mSoundPool.resume(id);
		}
	}
	static public void autoPause(){
		if(mSoundPool != null){
			mSoundPool.autoPause();
		}
	}
	static public void autoResume(){
		if(mSoundPool != null){
			mSoundPool.autoResume();
		}
	}
	static public void unloadSound(int inStreamID){
		if(mSoundPool!=null){
			mSoundPool.unload(inStreamID);
		}
	}
	static public void releasePool(){
		if(mSoundPool!=null){
			mSoundPool.release();
		}
	}
	static public void setVolume(int id, double left, double right){
		if(mSoundPool!=null){
			mSoundPool.setVolume(id,(float) left,(float) right);
		}
	}
	static public void setLoop(int id, int loop){
		if(mSoundPool!=null){
			mSoundPool.setLoop(id,loop);
		}
	}
	static public void setRate(int id, double rate){
		if(mSoundPool!=null){
			mSoundPool.setRate(id,(float)rate);
		}
	}
	
	static void clearPool(){
		//Log.v("Sound", "Clear pool");
		soundPoolIndices.clear();
		mSoundPool.release();
		mSoundPoolID++;
		mSoundPool = new SoundPool(soundpoolPolyphony, AudioManager.STREAM_MUSIC, 0);
	}
	
	private static int getMusicHandle(String inPath)
    {
		int id = GameActivity.getResourceID(inPath);
		return id;		
	}

	private static boolean musicIsPlaying = false;
	private static boolean mediaPlayerReleased = true;
	public static int playMusic(String inPath, double inVolLeft, double inVolRight, int inLoop, double inStartTime)
    {
		if(musicIsPlaying){
			stopMusic();
		}
    	if(mediaPlayer==null||mediaPlayerReleased){
        	Log.i("Sound", "Creating a new mediaplayer");
    		mediaPlayerReleased = false;
    		mediaPlayer = new MediaPlayer();
    		mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener(){
    			public void onPrepared(MediaPlayer mp){
    				mp.start();
    			}
    		});
    	}
    	musicIsPlaying = true;

		return playMediaPlayer(mediaPlayer, inPath, inVolLeft, inVolRight, inLoop, inStartTime);
	}

	private static int playMediaPlayer(MediaPlayer mp, final String inPath, double inVolLeft, double inVolRight, int inLoop, double inStartTime)
	{	
		int resourceID = getMusicHandle(inPath);
		try{
			if (resourceID < 0) { // not in bundle, try to play from filesystem
				if (inPath.charAt(0) == File.separatorChar) {
					try {
			        	FileInputStream fis = new FileInputStream(new File(inPath));
				        FileDescriptor fd = fis.getFD();
						mp.setDataSource(fd);
			        } catch(FileNotFoundException e) { 
			            System.out.println(e.getMessage());
			            return -1;
			        } catch(IOException e) { 
			            System.out.println(e.getMessage());
			            return -1;
			        }
			    }
			}else{
				mp.setDataSource(mContext, Utils.buildResourceUri(mContext,resourceID));
			}
			mp.setLooping(inLoop>0 || inLoop == -1);
			if(inStartTime!=0) mp.seekTo((int)inStartTime);
			mp.prepare();
		}catch(Exception e){
			e.printStackTrace();
			return -1;
		}
		return 0;
	}

	public static void stopMusic()
	{

		Log.v("Sound", "stopMusic");
		if (mediaPlayer != null) {
			mediaPlayer.stop ();
			mediaPlayer.reset();
		}
    	musicIsPlaying = false;
	}
	
	public static int getDuration(String inPath)
	{
		if (mediaPlayer != null) {
			return mediaPlayer.getDuration ();
		}
		return -1;
	}
	
	public static int getPosition(String inPath)
	{
		if (mediaPlayer != null) {
			return mediaPlayer.getCurrentPosition ();
		}
		return -1;
	}
	
	public static double getLeft(String inPath)
	{
		return 0.5;
	}
	
	public static double getRight(String inPath)
	{
		return 0.5;
	}
	
	public static boolean getComplete(String inPath)
	{
		return true;
	}

	public static void setMusicTransform(String inPath, double inVolLeft, double inVolRight)
	{
		if (mediaPlayer != null) {
			mediaPlayer.setVolume((float)inVolLeft, (float)inVolRight);
		}
	}
}
	