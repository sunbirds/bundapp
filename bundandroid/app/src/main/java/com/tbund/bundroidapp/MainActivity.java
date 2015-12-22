package com.tbund.bundroidapp;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.animation.AnimationUtils;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebChromeClient;
import android.widget.Button;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.Toast;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.weixin.controller.UMWXHandler;
import com.umeng.socialize.weixin.media.CircleShareContent;
import com.umeng.socialize.weixin.media.WeiXinShareContent;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Calendar;
import org.xwalk.core.XWalkView;
import static com.tbund.bundroidapp.R.id.inAppBrowser;


public class MainActivity extends Activity {

    private UMSocialService mController;
    private String title = "";
    private String image = "";
    private String link = "";
    private String postid = "";
    private String usertoken = "";
    private Boolean webHideBtn = false;


    public class WebAppInterface {
        Context mContext;
        WebView webView;

        /** Instantiate the interface and set the context */
        WebAppInterface(Context c,WebView w) {
            mContext = c;
            webView = w;
        }

        @org.xwalk.core.JavascriptInterface
        public void openWeb(String data) {
            if(data.startsWith("doinappbrowser")){
                data = data.replace("doinappbrowser?title=","");
                data = data.replace("appimage=","");
                data = data.replace("applink=","");
                data = data.replace("apppostid=","");
                data = data.replace("appusertoken=","");
                String result[] = data.split("&");

                if(result[0].equals("") || result[1].equals("") || result[2].equals("")){
                    return;
                }else {
                    try {
                        title =  java.net.URLDecoder.decode(result[0], "UTF-8");
                        image =  java.net.URLDecoder.decode(result[1], "UTF-8");
                        link =  java.net.URLDecoder.decode(result[2], "UTF-8");
                        postid = java.net.URLDecoder.decode(result[3], "UTF-8");
                        usertoken = java.net.URLDecoder.decode(result[4], "UTF-8");
                        webHideBtn = false;
                    }catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }

                    webView.post(new Runnable() {
                        @Override
                        public void run() {
                            ((MainActivity) mContext).openWeb(link);
                        }
                    });
                }
            }else if(data.startsWith("doad")){
                data = data.replace("doad?link=","");
                if(data.equals("")){
                    return;
                }else{
                    link =  data;
                    webHideBtn = true;

                    webView.post(new Runnable() {
                        @Override
                        public void run() {
                            ((MainActivity) mContext).openWeb(link);
                        }
                    });
                };
            }

        }

        @org.xwalk.core.JavascriptInterface
        public void androidShare(String url) {
            url = url.replace("doFavorite?title=","");
            url = url.replace("image=","");
            url = url.replace("link=","");
            String result[] = url.split("&");

            if(result[0].equals("")  || result[1].equals("") || result[2].equals("")){
                return;
            }else {
                try {
                    title =  java.net.URLDecoder.decode(result[0], "UTF-8");
                    image =  java.net.URLDecoder.decode(result[1], "UTF-8");
                    link =  java.net.URLDecoder.decode(result[2], "UTF-8");
                }catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                ((MainActivity)mContext).share();
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        com.umeng.socialize.utils.Log.LOG = true;
        setContentView(R.layout.activity_main);

        final MainActivity self = this;
        final WebView webView = (WebView)findViewById(inAppBrowser);
        XWalkView xWalkWebView =(XWalkView)findViewById(R.id.xwalkWebView);
        xWalkWebView.addJavascriptInterface(new WebAppInterface(this, webView), "Android");
        xWalkWebView.load("http://www.bundpic.com/webapp/index.html", null);

        new android.os.Handler().postDelayed(
                new Runnable() {
                    public void run() {
                        RelativeLayout splash = (RelativeLayout)findViewById(R.id.splash);
                        splash.setVisibility(RelativeLayout.GONE);
                    }
                },
                2000);

        mController = UMServiceFactory.getUMSocialService("com.umeng.share");

        String appID = "wxd1adb4ea31ffefeb";
        String appSecret = "ab616d4542e0a43b627536a37dfea284";
//      添加微信平台
        UMWXHandler wxHandler = new UMWXHandler(this,appID,appSecret);
        wxHandler.addToSocialSDK();
//      添加微信朋友圈
        UMWXHandler wxCircleHandler = new UMWXHandler(this,appID,appSecret);
        wxCircleHandler.setToCircle(true);
        wxCircleHandler.addToSocialSDK();

        mController.getConfig().removePlatform(SHARE_MEDIA.TENCENT);

//        Button btn = (Button)findViewById(R.id.btn);
//        btn.setOnClickListener(new OnClickListener() {
//            @Override
//            public void onClick(View v) {
//
//
//            }
//        });

        Button backbtn = (Button)findViewById(R.id.backBtn);
        backbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                RelativeLayout webViewContainer = (RelativeLayout)findViewById(R.id.webViewContainer);
                webViewContainer.setVisibility(RelativeLayout.GONE);
                webViewContainer.startAnimation(AnimationUtils.loadAnimation(self, R.anim.abc_fade_out));
                getWebView(inAppBrowser, "");
            }
        });

        Button favbtn = (Button)findViewById(R.id.favBtn);
        favbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(usertoken.equals("undefined") ){
                    Toast.makeText(self,"请登录后收藏",Toast.LENGTH_SHORT).show();
                }else {
                    self.http();
                }
            }
        });

        Button sharebtn = (Button)findViewById(R.id.shareBtn);
        sharebtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                self.share();
            }
        });

    }

    private Boolean exitFlag = true;
    private int lastTime = 0;
    private int thisTime = 0;
    @Override
    public void onBackPressed() {
        if(exitFlag) {
            Calendar time = Calendar.getInstance();
            lastTime = time.get(Calendar.SECOND);
            Toast.makeText(this,"再次点击退出",Toast.LENGTH_SHORT).show();
            exitFlag = false;
        } else {
            Calendar time = Calendar.getInstance();
            thisTime = time.get(Calendar.SECOND);
            if(thisTime - lastTime <= 3){
                super.onBackPressed();
            }else {
                exitFlag = true;
                Toast.makeText(this,"再次点击退出",Toast.LENGTH_SHORT).show();
            }
        }
    }

    public WebView getWebView(int id, String url) {
        WebView web = (WebView)findViewById(id);
        web.setWebChromeClient(new WebChromeClient());
        WebSettings settings = web.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);
        web.loadUrl(url);
        return web;
    }

    public void openWeb(String webLink){
        Button sharebtn = (Button)findViewById(R.id.shareBtn);
        Button favbtn = (Button)findViewById(R.id.favBtn);
        if(webHideBtn){
            sharebtn.setVisibility(View.INVISIBLE);
            favbtn.setVisibility(View.INVISIBLE);
        }else {
            sharebtn.setVisibility(View.VISIBLE);
            favbtn.setVisibility(View.VISIBLE);
        }
        getWebView(inAppBrowser, webLink);
        RelativeLayout webViewContainer = (RelativeLayout) findViewById(R.id.webViewContainer);
        webViewContainer.setVisibility(RelativeLayout.VISIBLE);
        webViewContainer.startAnimation(AnimationUtils.loadAnimation(this, R.anim.abc_fade_in));
    }

    public String getHttp(String dataurl){

        URL url;
        HttpURLConnection connection = null;
        String responseStr = "";
        try {
            // Create connection
            url = new URL(dataurl);
            connection = (HttpURLConnection) url.openConnection();
            // Get Response
            InputStream is = connection.getInputStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is));
            String line;
            StringBuffer response = new StringBuffer();
            while ((line = rd.readLine()) != null) {
                response.append(line);
            }
            rd.close();
            responseStr = response.toString();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
        return responseStr;
    }

    public String postHttp(String dataurl, String postData){
        String dataUrlParameters = postData;
        URL url;
        HttpURLConnection connection = null;
        String responseStr = "";
        try {
            // Create connection
            url = new URL(dataurl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");

            // Send request
            DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
            wr.writeBytes(dataUrlParameters);
            wr.flush();
            wr.close();

            // Get Response
            InputStream is = connection.getInputStream();
            BufferedReader rd = new BufferedReader(new InputStreamReader(is));
            String line;
            StringBuffer response = new StringBuffer();
            while ((line = rd.readLine()) != null) {
                response.append(line);
                response.append('\r');
            }
            rd.close();
            responseStr = response.toString();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
        return responseStr;
    }

    public void http(){
        final MainActivity self = this;
        Thread http = new Thread() {
            @Override
            public void run() {

                String getResult = getHttp("http://www.bundpic.com/app-addfav?p="+postid+"&c="+usertoken);

                if(getResult.equals("0")){
                    runOnUiThread(new Runnable() {
                        public void run() {
                            Toast.makeText(self, "收藏成功", Toast.LENGTH_SHORT).show();
                            Button favbtn = (Button)findViewById(R.id.favBtn);
                            favbtn.setBackgroundResource(R.drawable.onfav);
                        }
                    });


                }else if(getResult.equals("5")){
                    getHttp("http://www.bundpic.com/app-delfav?p="+postid+"&c="+usertoken);
                    runOnUiThread(new Runnable() {
                        public void run() {
                            Toast.makeText(self, "取消收藏", Toast.LENGTH_SHORT).show();
                            Button favbtn = (Button) findViewById(R.id.favBtn);
                            favbtn.setBackgroundResource(R.drawable.fav);
                        }
                    });

                }
            }
        };
        http.start();

    }

    public void share() {
        this.runOnUiThread(new Runnable() {
            @Override
            public void run() {

                // 设置分享内容
                mController.setShareContent(title + link);
                // 设置分享图片, 参数2为图片的url地址
                mController.setShareMedia(new UMImage(MainActivity.this, image));

                //设置微信好友分享内容
                WeiXinShareContent weixinContent = new WeiXinShareContent();
                //设置分享文字
                weixinContent.setShareContent(title);
                //设置title
                weixinContent.setTitle(title);
                //设置分享内容跳转URL
                weixinContent.setTargetUrl(link);
                //设置分享图片
                weixinContent.setShareImage(new UMImage(MainActivity.this, image));
                mController.setShareMedia(weixinContent);

                //设置微信朋友圈分享内容
                CircleShareContent circleMedia = new CircleShareContent();
                circleMedia.setShareContent(title);
                //设置朋友圈title
                circleMedia.setTitle(title);
                circleMedia.setShareImage(new UMImage(MainActivity.this, image));
                circleMedia.setTargetUrl(link);
                mController.setShareMedia(circleMedia);

                mController.openShare(MainActivity.this, false);
            }
        });
    }
}
