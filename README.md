# Protect_Sudoku_app
通过加壳保护app
0、建立要加壳的android工程
在工程中添加MyApplication类
package com.shipc.sudoku;

import android.app.Application;
import android.util.Log;

public class MyApplication extends Application{

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i("demo", "source apk onCreate:"+this);
    }

}
在Manifest文件中指定application名称为"com.shipc.sudoku.MyApplication"
<?xml version= "1.0" encoding ="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.shipc.sudoku"
    android:versionCode= "1"
    android:versionName= "1.0" >

    <uses-sdk
        android:minSdkVersion="17"
        android:targetSdkVersion="22" />

    <application
        android:name ="com.shipc.sudoku.MyApplication"
        android:allowBackup="true"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme" >
        <activity
            android:name=".Sudoku"
            android:label="@string/app_name" >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity
            android:name=".About"
            android:label="@string/about_title"
            android:theme="@android:style/Theme.Dialog" >
        </activity>
        <activity
            android:name=".Settings"
            android:label="@string/setting_title" >
        </activity>
        <activity
            android:name=".Game"
            android:label="@string/game_title" >
        </activity> >
    </application >

</manifest>

1、建立脱壳没有activity的android工程
为应用创建ProxyApplication类和RefInvoke类用于，apk解密和类加载。
2、在Manifest文件中为目标apk的activity添加定义
<?xml version= "1.0" encoding ="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.teligen.unshell"
    android:versionCode= "1"
    android:versionName= "1.0" >

    <uses-sdk
        android:minSdkVersion="19"
        android:targetSdkVersion="21" />

    <application
        android:allowBackup="false"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/AppTheme"
        android:name="com.teligen.unshell.ProxyApplication" >
<!--在此添加了应用名称就是在这，将我们一直用的默认Application给设置成我们自己做的ProxyApplication，ProxyApplication类的作用就是为了放一些全局的和一些上下文都要用到的变量和方法之类的-->
       <!--添加meta-data项，指定要被加壳的应用的application名称-->
        <meta-data android:name="APPLICATION_CLASS_NAME" android:value="com.shipc.sudoku.MyApplication" />

       <!--以下内容源自要加壳的app所拥有的activity，android:name赋值应当为被加壳程序的类的路径-->
        <activity
            android:name="com.shipc.sudoku.Sudoku"
            android:label="@string/app_name" >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity
            android:name="com.shipc.sudoku.About"
            android:label="@string/about_title"
            android:theme="@android:style/Theme.Dialog" >
        </activity>
        <activity
            android:name="com.shipc.sudoku.Settings"
            android:label="@string/setting_title" >
        </activity>
        <activity
            android:name="com.shipc.sudoku.Game"
            android:label="@string/game_title" >
        </activity> >
    </application >

</manifest>

3、然后将目标apk的res文件夹下的内容layout、values等文件拷贝至脱壳工程的res目录下

4、建立Dex文件加密工程DexShellTool，该程序目的用于将壳程序的DEX文件和被加壳程序的apk文件加密后合并成一个新的Classes.dex文件。

5、生成要加壳的应用APK文件，Sudoku.apk

6、生成脱壳的classes.dex文件

7、将两个文件拷贝至DexShellTool的force目录下，运行renameFile.bat

8、运行DexShellTool的java应用，生成classes.dex

9、在Unshell工程（脱壳工程）下导出未签名的apk，然后使用winrar打开该apk文件，替换其中的dex文件为上一部生成的dex文件。

10、对重新打包后的apk文件进行签名，签名的密码为ＸＸＸＸＸＸ
jarsigner -verbose -keystore teligen.keystore -signedjar Unshell_signed.apk Unshell.apk teligen.keystore

11、生成apk文件，就可以安装使用了
