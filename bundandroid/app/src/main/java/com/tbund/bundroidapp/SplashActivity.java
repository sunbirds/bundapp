package com.tbund.bundroidapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;

public class SplashActivity extends Activity {

//    private static String TAG = SplashActivity.class.getName();
//    private static long SLEEP_TIME = 1;    // Sleep for some time
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//
//        this.requestWindowFeature(Window.FEATURE_NO_TITLE);    // Removes title bar
//        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,     WindowManager.LayoutParams.FLAG_FULLSCREEN);    // Removes notification bar
//
//        setContentView(R.layout.splash);
//
//        // Start timer and launch main activity
//        IntentLauncher launcher = new IntentLauncher();
//        launcher.start();
//    }
//
//    private class IntentLauncher extends Thread {
//        @Override
//        /**
//         * Sleep for some time and than start new activity.
//         */
//        public void run() {
//            try {
//                // Sleeping
//                Thread.sleep(300);
//            } catch (Exception e) {
//                Log.e(TAG, e.getMessage());
//            }
//
//            // Start main activity
//            Intent intent = new Intent(SplashActivity.this, MainActivity.class);
//            intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
//            SplashActivity.this.startActivity(intent);
//            SplashActivity.this.overridePendingTransition(0, 0);
////            SplashActivity.this.finish();
//
//        }
//    }
}