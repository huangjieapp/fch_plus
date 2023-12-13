//6666
//  AppDelegate.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/3/14.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBAppDelegate.h"
#import "DBAppDelegate+DBDefault.h"
#import "NewUserSession.h"
#import "iflyMSC/IFlyMSC.h"
#import "WXApi.h"
#import "BPush.h"
#import <UserNotifications/UserNotifications.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "DBBaseViewController.h"
#import "DBNavigationController.h"
#import "DBTabBarViewController.h"
#import "SHLoginViewController.h"
#import "CGCTemplateVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <Bugly/Bugly.h>

#import "MJKTestViewController.h"



// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <OCRunner.h>
#import <SSZipArchive.h>



#define IMAPPKEY @"1148170925115402#mjk-test"
#define IMAPNSEDV @"develop"
#define IMAPNSPRO @"distribution"


#define AliAPIKey           @"5bf5b2e7b03d4d361dd090fc7b9e4862" //高德地图
#define BDMapAK          @"wRHsegRQZBEdyyGL1n0HZpO0F0TwSUNd"
#define BDPushAppKey     @"ddhjTGgR6yyHdBCw5BCxK0qK"
#define EZappKey         @"e05edd320ce0425fb137bcd89e01be40"
#define WXappid          @"wxcc368c629bbc4ff8"
#define XFID             @"5aea88ba" 



#define SUPPORT_IOS8 1
//注意，关于 iOS10 系统版本的判断，可以用下面这个宏来判断。不能再用截取字符的方法。
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface DBAppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate/*,
                            EMClientDelegate*/>

/** baidu manager*/
@property (nonatomic, strong) BMKMapManager *mapManager;
@end

@implementation DBAppDelegate



// 当文件名为中文时，解决url编码问题
- (NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSLog(@"decodedString = %@",decodedString);
    return decodedString;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadOCRunner];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    //bugly
     [Bugly startWithAppId:@"1cc595d9bb"];
    
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
	{
		//由于IOS8中定位的授权机制改变 需要进行手动授权
//		self.locationManager = [[AMapLocationManager alloc] init];
		//获取授权认证
//		[self.locationManager stopUpdatingLocation];
//		[self.locationManager stopUpdatingLocation];
	}
	
	//极光推送
	
	
	// Override point for customization after application launch.
	NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
	
	// 3.0.0及以后版本注册
	JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
	if (@available(iOS 12.0, *)) {
		entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
	} else {
		entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
	}
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		//可以添加自定义categories
		//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
		//      NSSet<UNNotificationCategory *> *categories;
		//      entity.categories = categories;
		//    }
		//    else {
		//      NSSet<UIUserNotificationCategory *> *categories;
		//      entity.categories = categories;
		//    }
	}
	[JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
	
	//如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"6558a4419f6f02f54d5731d8"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:advertisingId];
    
	
	//2.1.9版本新增获取registration id block接口。
	[JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
		if(resCode == 0){
			NSLog(@"registrationID获取成功：%@",registrationID);
			
		}
		else{
			NSLog(@"registrationID获取失败，code：%d",resCode);
		}
	}];
	
	
	//百度地图AK
	_mapManager = [[BMKMapManager alloc] init];
	BOOL ret = [_mapManager start:BDMapAK generalDelegate:nil];
	if (!ret) {
		[JRToast showWithText:@"baidu map manager start failed!"];
	}
	
	[[BMKLocationAuth sharedInstance] checkPermisionWithKey:BDMapAK authDelegate:nil];
//    //融云聊天室
//    // 秘钥  lKx7mclZAFC3nB
//    [[RCDLive sharedRCDLive] initRongCloud:RONGCLOUD_IM_APPKEY];
//    //注册自定义消息
//    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
//
//
//    //中英文
//    [DBLanguageTool initUserLanguage];
//    
//    
//    //友盟
//    [self setUpUMShare];
//    
//    
//    //七牛云
//     [PLStreamingEnv initEnv];
//    
//
//    //检测网络状态
//    [AppDelegate AFNetworkStatus];
//    
//    //广告页和引导页在首页上
//    
//    
//    DBNewLoginViewController* vc=[[DBNewLoginViewController alloc]initWithNibName:@"DBNewLoginViewController" bundle:nil];
//    XLNavigationController*navi=[[XLNavigationController alloc]initWithRootViewController:vc];
//    self.window= [AppDelegate windowInitWithRootViewController:navi];
//    
//    return YES;
    
    
    /*
     *  注册推送  和 百度推送
     */
    
    /*
     *  萤石
     */

    /*
     *  微信
     */

    /*
     * 讯飞
     */

    
    #pragma mark  --start
    
//    NSString*lastLoginTime=[KUSERDEFAULT objectForKey:LoginFlag];
//    NSString*currentDay=[DBTools getYearMonthDayTime];
//    
//    if ([lastLoginTime isEqualToString:currentDay]) {
//        //跳tab
//        XLTabBarViewController*tab=[[XLTabBarViewController alloc]init];
//        [DBAppDelegate windowInitWithRootViewController:tab];
//        
//    }else{
//        //跳登录界面
//        SHLoginViewController*tab=[[SHLoginViewController alloc]init];
//        [DBAppDelegate windowInitWithRootViewController:tab];
//
//    }
    
    
    
    
    
#pragma mark  --history
    /*
     高德地图-----------------
     */
    
    [self configureAPIKey];
	

	// 清除角标
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	// 测试本地通知
//	[self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
	
    


	
    
    
    /*
     * 微信
     */
        
    //    向微信注册
    [WXApi registerApp:WXappid universalLink:@"https://help.wechat.com/app/"];
    //向微信注册支持的文件类型
//    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
//
//    [WXApi registerAppSupportContentFlag:typeFlag];
    
    
    
    
    /*
     *科大讯飞
     */
    ////    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",XFID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    

    
    
    
    /**
     * 环信
	
    EMOptions *options=[EMOptions optionsWithAppkey:IMAPPKEY];
    options.apnsCertName=IMAPNSEDV;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
	 
     * 环信
     */
    
    SHLoginViewController*Login=[[SHLoginViewController alloc]initWithNibName:@"SHLoginViewController" bundle:nil];
//    DBTabBarViewController*tabVC=[[DBTabBarViewController alloc]init];
    self.window=[DBAppDelegate windowInitWithRootViewController:Login];
    



    
    return YES;
}

- (void)loadOCRunner {
    [ORSystemFunctionPointerTable reg:@"CGPointEqualToPoint" pointer:&CGPointEqualToPoint];
    [ORSystemFunctionPointerTable reg:@"CGSizeEqualToSize" pointer:&CGSizeEqualToSize];
    [ORSystemFunctionPointerTable reg:@"dispatch_block_perform" pointer:&dispatch_block_perform];
#if DEBUG
    NSString *finalPath = [[NSBundle mainBundle] pathForResource:@"binarypatch" ofType:nil];
    [ORInterpreter excuteBinaryPatchFile:finalPath];
#else
    //创建信号量，保证先把补丁包下载下来再进入主页面，若补丁包大的话，可以考虑不阻塞主线程，给予等待loding显示
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://gitee.com/you-shun-information/binarypatch_fch/releases/download/1.0/binarypatch_Use.zip"]];
       
       NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
           //打印下载进度
           NSLog(@"%f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
       } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
           
           NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
           NSString *fullPath = [filePath stringByAppendingPathComponent:response.suggestedFilename];
           NSFileManager *fileManager = [NSFileManager defaultManager];
           if ([fileManager fileExistsAtPath:fullPath]) {
               [fileManager removeItemAtPath:fullPath error:nil];
           }
           NSLog(@"%@",fullPath);
           return [NSURL fileURLWithPath:fullPath];
           
       } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
           
           NSLog(@"%@",filePath);
           NSLog(@"completionHandler----%@",error);
           NSString *filePathStr = filePath.relativePath;
          NSString *toPath = [filePathStr stringByDeletingLastPathComponent];
          NSString *finalPath = [NSString stringWithFormat:@"%@/binarypatch", toPath];
           NSFileManager *fileManager = [NSFileManager defaultManager];
                   if ([fileManager fileExistsAtPath:finalPath]) {
                       [fileManager removeItemAtPath:finalPath error:nil];
                   }
           [SSZipArchive unzipFileAtPath:filePathStr toDestination:toPath progressHandler:nil completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
              NSLog(@"File unzip to: %@", finalPath);
               NSLog(@"File unzip error: %@", error);
               [ORInterpreter excuteBinaryPatchFile:finalPath];
               dispatch_semaphore_signal(semaphore);
           }];
           
       }];
       
       [downTask resume];
    //信号量等待
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
#endif
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[JPUSHService handleRemoteNotification:userInfo];
	NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
	[JPUSHService handleRemoteNotification:userInfo];
	NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
	
	if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
	}
	
	completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
	[JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
	NSDictionary * userInfo = notification.request.content.userInfo;
	
	UNNotificationRequest *request = notification.request; // 收到推送的请求
	UNNotificationContent *content = request.content; // 收到推送的消息内容
	
	NSNumber *badge = content.badge;  // 推送消息的角标
	NSString *body = content.body;    // 推送消息体
	UNNotificationSound *sound = content.sound;  // 推送消息的声音
	NSString *subtitle = content.subtitle;  // 推送消息的副标题
	NSString *title = content.title;  // 推送消息的标题
	
	if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		[JPUSHService handleRemoteNotification:userInfo];
		NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
		
		
	}
	else {
		// 判断为本地通知
		NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
	}
	completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
	
	NSDictionary * userInfo = response.notification.request.content.userInfo;
	UNNotificationRequest *request = response.notification.request; // 收到推送的请求
	UNNotificationContent *content = request.content; // 收到推送的消息内容
	
	NSNumber *badge = content.badge;  // 推送消息的角标
	NSString *body = content.body;    // 推送消息体
	UNNotificationSound *sound = content.sound;  // 推送消息的声音
	NSString *subtitle = content.subtitle;  // 推送消息的副标题
	NSString *title = content.title;  // 推送消息的标题
	
	if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
		[JPUSHService handleRemoteNotification:userInfo];
		NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
		
	}
	else {
		// 判断为本地通知
		NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
	}
	
	completionHandler();  // 系统要求执行这个方法
}
#endif

#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
	NSString *title = nil;
	if (notification) {
		title = @"从通知界面直接进入应用";
	}else{
		title = @"从系统设置界面进入应用";
	}
	UIAlertView *test = [[UIAlertView alloc] initWithTitle:title
												   message:@"pushSetting"
												  delegate:self
										 cancelButtonTitle:@"yes"
										 otherButtonTitles:nil, nil];
	[test show];
	
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
	if (![dic count]) {
		return nil;
	}
	NSString *tempStr1 =
	[[dic description] stringByReplacingOccurrencesOfString:@"\\u"
												 withString:@"\\U"];
	NSString *tempStr2 =
	[tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
	NSString *tempStr3 =
	[[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
	NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
	NSString *str =
	[NSPropertyListSerialization propertyListFromData:tempData
									 mutabilityOption:NSPropertyListImmutable
											   format:NULL
									 errorDescription:NULL];
	return str;
}

#pragma Gegistnotification





// 当 DeviceToken 获取失败时，系统会调用此回调方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"DeviceToken 获取失败， 原因是： %@", error);
}

// 当注册成功时候返回 deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	NSLog(@"%@-----", deviceToken);
	/// Required - 注册 DeviceToken
	[JPUSHService registerDeviceToken:deviceToken];
	NSString *str = [DBTools uuid];
	[JPUSHService setAlias:str completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
		MyLog(@"%@-=0000=-%@",iAlias,str);
	} seq:1];
}






#pragma mark - 测试本地通知
- (void)testLocalNotifi
{
	NSLog(@"测试本地通知啦！！！");
	NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:5];
	
}

//极光推送通知name:kJPFNetworkDidReceiveMessageNotification回调
- (void)networkDidReceiveMessage:(NSNotification *)notification {
	NSDictionary * userInfo = [notification userInfo];
	NSString *content = [userInfo valueForKey:@"content"];
	NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
	NSDictionary *extras = [userInfo valueForKey:@"extras"];
	NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
	
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice{

}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer{

}

#pragma mark  --history
- (void)registerAPNS
{
    NSLog(@"Registering for push notifications...");
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([url.scheme isEqualToString:WXappid]) {
        NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"send"];
        
        if ([key isEqualToString:@"send"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tongzhisend" object:nil];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"send"];
            
        }
        
        
        return [WXApi handleOpenURL:url delegate:self];
        
    }
    if (self.window) {
        if (url) {
            NSString *fileName = url.lastPathComponent; // 从路径中获得完整的文件名（带后缀）
            // path 类似这种格式：file:///private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
            NSString *path = url.absoluteString; // 完整的url字符串
            path = [self URLDecodedString:path]; // 解决url编码问题
            
            NSMutableString *string = [[NSMutableString alloc] initWithString:path];
            
            if ([path hasPrefix:@"file://"]) { // 通过前缀来判断是文件
                // 去除前缀：/private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
                [string replaceOccurrencesOfString:@"file://" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, path.length)];
                
                // 此时获取到文件存储在本地的路径，就可以在自己需要使用的页面使用了
                NSDictionary *dict = @{@"fileName":fileName,
                                       @"filePath":string};
                
                if ([NewUserSession instance].user.u051Id.length > 0) {
                    MJKTestViewController *vc = [[MJKTestViewController alloc]init];
                    vc.fileDic = dict;
                    DBTabBarViewController *tabVC = (DBTabBarViewController *)self.window.rootViewController;
                    [tabVC presentViewController:vc animated:YES completion:nil];
                } else {
                    SHLoginViewController *tabVC = (SHLoginViewController *)self.window.rootViewController;
                    tabVC.fileDic = dict;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FileNotification" object:nil userInfo:dict];
                }
                
                
                return YES;
            }
        }
    }
    //    else
    //        {
    //            [[IFlySpeechUtility getUtility] handleOpenURL:url];
    //        }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url

{
    
    
    return  [WXApi handleOpenURL:url delegate:self];
    
}

-(void)onResp:(BaseResp*)resp{
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        SendMessageToWXResp *response=(SendMessageToWXResp*)resp;
        switch(response.errCode){
                
            case WXSuccess:
                
               [[NSNotificationCenter defaultCenter] postNotificationName:WXSHARESUCCESS object:nil];
                break;
            default:
            
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }

       
    }
   
    
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
                
            case WXSuccess:
                
                //服务器端查询支付通知或查询API返回的结果再提示成功
                //                [self backSuccess];
                NSLog(@"支付成功");
                break;
            default:
                
                //                [self backFailed];
                
                
                
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    
    
    
    
}






#pragma mark  --友盟
////友盟分享
//-(void)setUpUMShare{
//    /* 打开调试日志 */
//    [[UMSocialManager defaultManager] openLog:YES];
//     [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
//    
//    /* 设置友盟appkey */
//    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58c7c852f5ade420af000d59"];
//    
//    [self configUSharePlatforms];
//    
//    [self confitUShareSettings];
//
//    
//}
//
//- (void)confitUShareSettings
//{
//    
//    
//    /*
//     * 打开图片水印
//     */
//    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
//    
//    /*
//     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
//     <key>NSAppTransportSecurity</key>
//     <dict>
//     <key>NSAllowsArbitraryLoads</key>
//     <true/>
//     </dict>
//     */
//    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
//    
//}
//
//- (void)configUSharePlatforms
//{
//    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx1b5d3303d7e63ba6" appSecret:@"d4f6d2e2b4546fcd6b51a3cce05eabe8" redirectURL:@"http://mobile.umeng.com/social"];
//    
//
//    
//    /*
//     * 移除相应平台的分享，如微信收藏
//     */
//    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
//    
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105856597"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
//    
//    /* 设置新浪的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1878019184"  appSecret:@"c479daea0949f9a5959b12e7a08c2d73" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
//}


#pragma mark -- 回调
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
//    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        if ([url.host isEqualToString:@"safepay"]) {
//            // 支付跳转支付宝钱包进行支付，处理支付结果
////            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
////                NSLog(@"result = %@",resultDic);
////            }];
//        }else{
////             return  [WXApi handleOpenURL:url delegate:[DBBaseViewController sharedManager]];
//        }
//
//        
//        
//        return YES;
//    }
//    return result;
//}
//
//#endif
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url ];
//    if (!result) {
//        // 其他如支付等SDK的回调
//        if ([url.host isEqualToString:@"safepay"]) {
//            // 支付跳转支付宝钱包进行支付，处理支付结果
////            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
////                NSLog(@"result = %@",resultDic);
////            }];
//        }else{
////            return  [WXApi handleOpenURL:url delegate:[DBBaseViewController sharedManager]];
//        }
//        
//        
//        
//        return YES;
//
//        
//        
//    }
//    return result;
//}
//
//
//
//
//
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"enterBackground"];
    /**
     * 环信
	 
     [[EMClient sharedClient] applicationDidEnterBackground:application];*/
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"WillEnterForeground" object:nil];
//    //    获取手机程序的版本号
//    NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
//    //POST必须上传的字段
//    NSDictionary *dict = @{@"id":@"1271259569"};//此处的Apple ID
//    
//    [mgr POST:@"https://itunes.apple.com/lookup" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        
//        
//        
//        NSArray *array = responseObject[@"results"];
//        if (array.count != 0) {// 先判断返回的数据是否为空
//            NSDictionary *dict = array[0];
//            
//            NSString *nowVersion = dict[@"version"] ;
//            
//            //判断版本  [dict[@"version"] floatValue] > [ver floatValue]
//            if (![nowVersion isEqualToString:ver]) {
//                
//                UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"版本更新" message:@"你的版本不是最新版，需要更新？" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }];
//                UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                    
//                    //跳转到appStore 下载去
//                    //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E8%84%89%E5%B1%85%E5%AE%A2/id1271259569?mt=8"]];
//                    NSString *str = @"https://itunes.apple.com/cn/app/%E8%84%89%E5%B1%85%E5%AE%A2/id1271259569?mt=8";
//                    NSURL *url = [NSURL URLWithString:str];
//                    [[UIApplication sharedApplication] openURL:url];
//                    
//                    
//                }];
//                //                [alertVC addAction:cancel];
//                [alertVC addAction:sure];
//                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//                
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSArray *array =nil;
//    }];
   /*  * 环信
	 
      [[EMClient sharedClient] applicationWillEnterForeground:application]; */
	
	
//	[self nextDayLogin];
	[application setApplicationIconBadgeNumber:0];
	[application cancelAllLocalNotifications];
	
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeAll completion:nil];
//    [[SDImageCache sharedImageCache] clearMemory];
    [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeMemory completion:nil];
}
#pragma mark - 隔天注销
//- (void)nextDayLogin {
//	NSString *nowTimeStr = [DBTools getTimeFomatFromCurrentTimeStamp];
//	NSString *lastLoginDate = [NewUserSession instance].D_LASTUPDATE_TIME;
//
//	NSString *nowDay;
//	NSString *lastLoginDay;
//
//	if (nowTimeStr.length > 0) {
//				nowDay = [nowTimeStr substringWithRange:NSMakeRange(8, 2)];
////		nowDay = [nowTimeStr substringFromIndex:17];
//	}
//	if (lastLoginDate.length > 0) {
//				lastLoginDay = [lastLoginDate substringWithRange:NSMakeRange(8, 2)];
////		lastLoginDay = [lastLoginDate substringFromIndex:17];
//	}
//	if (nowDay.integerValue > lastLoginDay.integerValue) {
//		[NewUserSession cleanUser];
//	}
//}

#pragma mark  --funcation
- (void)configureAPIKey
{
    if ([AliAPIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    [AMapServices sharedServices].apiKey = (NSString *)AliAPIKey;
}



@end
