//
//  DBTools.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "DBTools.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation DBTools

#pragma mask 创建button
+ (UIButton *)creatButtonWithFrame:(CGRect)frame Target:(id)target Sel:(SEL)method Title:(NSString *)title ImageName:(NSString *)imageName BGImageName:(NSString *)bgImageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    //button.tintColor=[UIColor redColor];
    //button.tintColor=[UIColor whiteColor];
    if (imageName) {
        [button setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    
    //    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
    //    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mask 创建label
+ (UILabel *)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    //设置字体大小
    label.font = [UIFont systemFontOfSize:font];
    //设置折行方式，按照单词进行
    //    label.lineBreakMode = NSLineBreakByWordWrapping;
    //不限行数
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    //自适应
    //label.adjustsFontSizeToFitWidth = YES;
    return label ;
}

#pragma mark  --  哈希算法
+ (NSString *)sha1:(NSString *)inputString{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",digest[i]];
    }
    return [outputString lowercaseString];
}


//传入金额， 给金额打上逗号
+(NSString*)addSeparatorForPriceString:(NSString*)priceStr{
    NSString*price=priceStr;
    NSMutableString*tempStr=price.mutableCopy;
    NSRange range=[price rangeOfString:@"."];
    NSInteger index=0;
    if (range.length>0) {
        index=range.location;
    }else{
        index=price.length;
    }
    
    while ((index-3)>0) {
        index-=3;
        [tempStr insertString:@"," atIndex:index];
        
    }
    //    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"." withString:@","].mutableCopy;
    return tempStr;
    
}



// 缓存大小
+(CGFloat)folderSize{
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += (CGFloat)[[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}



+ (void)removeCache{
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError*error;
        
        NSString*path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager]fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                
            }else{
                
                NSLog(@"清除失败");
                
            } 
        }
    }
}



#pragma mark  --  get UUID
#define KEY_USERNAME_PASSWORD @"YWUUDID"   //UUDID
+(NSString *)getUUID{
    NSString * strUUID = [KUSERDEFAULT valueForKey:KEY_USERNAME_PASSWORD];
    if (strUUID)return strUUID;
    strUUID = (NSString *)[DBTools load:@"com.company.app.usernamepassword"];
    
    if ([strUUID isEqualToString:@""] || !strUUID){
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        [DBTools save:KEY_USERNAME_PASSWORD data:strUUID];
        [[NSUserDefaults standardUserDefaults] setObject:strUUID forKey:KEY_USERNAME_PASSWORD];
    }
    return strUUID;
}

+ (NSString *)uuid{

	NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:@" "account:@"uuid"];
	if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
	{
		NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
		currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
		currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
		currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
		[SSKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
	}
	return currentDeviceUUIDStr;

}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

//得到view 的父视图控制器
+(UIViewController*)getSuperViewWithsubView:(UIView*)subView{
    
    for (UIView* next = [subView superview]; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}


+(UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


#pragma mark  -- 广告位需要
/**
 *  判断文件是否存在
 */
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  根据图片名拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}








#pragma 关于时间
//传入 秒 得到 xx:xx:xx

+(NSString *)getHHMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@时%@分%@秒",str_hour,str_minute,str_second];
    return format_time;
}


//传入 秒 得到 xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@分%@秒",str_minute,str_second];
    return format_time;
}
//得到当前的时间戳
+(NSString *)getCurrentTimeStamp
{
    NSDate *datenow = [NSDate date];//现在时间
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    //NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}

+(NSString*)getYearMonthDayTime{
    NSDate *datenow = [NSDate date];//现在时间
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;

}

+(NSString*)getYearMonthTime{
    NSDate *datenow = [NSDate date];//现在时间
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;

}

//特定时间
+(NSString*)getYearMonthDayTimeWithDate:(NSDate *)date{
	NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	//    @"yy:MM:dd"
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString*getTimer=[dateFormatter stringFromDate:date];
	
	return getTimer;
	
}

//特定时间
+(NSDate*)getYearMonthDayTimeWithStr:(NSString *)date{
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*getTimer=[dateFormatter dateFromString:date];
    
    return getTimer;
    
}

+(NSString*)getTimeFomatFromCurrentTimeStampWithYMD{
    NSDate *datenow = [NSDate date];//现在时间
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;
    
}

+(NSString*)getTimeFomatFromTimeStampOnlyYMDAddDay:(NSInteger)day andNowTime:(NSString *)time {
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *datenow = [NSDate dateWithTimeInterval:day * 3600 * 24 sinceDate:[dateFormatter dateFromString:time]];//现在时间
    
    
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;
    
}

+(NSString*)getBeforeTimeFomatFromTimeStampOnlyYMDAddDay:(NSInteger)day andNowTime:(NSString *)time {
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *datenow = [NSDate dateWithTimeInterval:-(day * 3600 * 24) sinceDate:[dateFormatter dateFromString:time]];//现在时间
    
    
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;
    
}



//得到当前的时间点格式化好的了   @"yyyy-MM-dd HH:mm:ss"
+(NSString*)getTimeFomatFromCurrentTimeStamp{
    NSDate *datenow = [NSDate date];//现在时间
      NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*getTimer=[dateFormatter stringFromDate:datenow];

    return getTimer;
    
}

//得到当前的时间点后三个小时格式化好的了   @"yyyy-MM-dd HH:mm:ss"
+(NSString*)getTimeFomatFromCurrentTimeStampAddThreeTime{
	NSDate *datenow = [NSDate dateWithTimeIntervalSinceNow:3 * 60 * 60];//现在时间
	
	NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	//    @"yy:MM:dd"
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString*getTimer=[dateFormatter stringFromDate:datenow];
	
	return getTimer;
	
}

//得到特定的时间点后三个小时格式化好的了   @"yyyy-MM-dd HH:mm:ss"
+(NSString*)getTimeFomatFromTimeStampAddThreeTime:(NSString *)time {
	NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	//    @"yy:MM:dd"
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *datenow = [NSDate dateWithTimeInterval:3 * 60 * 60 sinceDate:[dateFormatter dateFromString:time]];//现在时间
	
	
	NSString*getTimer=[dateFormatter stringFromDate:datenow];
	
	return getTimer;
	
}

//得到当前时间后几天的时间   @"yyyy-MM-dd HH:mm:ss"
+(NSString*)getTimeFomatFromTimeStampAddDay:(NSInteger)day {
    NSDate *date = [NSDate date];
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate dateWithTimeInterval:day * 3600 * 24 sinceDate:date];//现在时间
    
    
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;
    
}

+(NSString*)getTimeFomatFromTimeStampAddDay:(NSInteger)day andTime:(NSString *)time {
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate dateWithTimeInterval:day * 3600 * 24 sinceDate:[dateFormatter dateFromString:time]];//现在时间
    
    
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;
    
}

//得到特定的时间点后三个小时格式化好的了   @"yyyy-MM-dd HH:mm:ss"
+(NSString*)getTimeFomatFromTimeStampSubThreeTime:(NSString *)time {
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate dateWithTimeInterval:-3 * 60 * 60 sinceDate:[dateFormatter dateFromString:time]];//现在时间
    
    
    NSString*getTimer=[dateFormatter stringFromDate:datenow];
    
    return getTimer;
    
}

//得到当前的时间点格式化好的了   @"yyyy-MM-dd HH:mm:ss EEE"
+(NSString*)getWeeksTimeFomatFromCurrentTimeStamp{
	NSDate *datenow = [NSDate date];//现在时间
	NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	//    @"yy:MM:dd"
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss EEE"];
	NSString*getTimer=[dateFormatter stringFromDate:datenow];
	
	return getTimer;
	
}

//得到当前的时间点格式化好的了   @"yyyy-MM-dd EEE"
+(NSString*)getWeeksFomatFromCurrentTimeStamp{
	NSDate *datenow = [NSDate date];//现在时间
	NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	//    @"yy:MM:dd"
	[dateFormatter setDateFormat:@"yyyy-MM-dd EEE"];
	NSString*getTimer=[dateFormatter stringFromDate:datenow];
	
	return getTimer;
	
}

//得到当前的时间点格式化好的了   @"yyyy-MM-dd EEE"
+(NSString*)getWeeksFomatFromCurrentTimeStampWithDays:(NSTimeInterval)dayFloat{
//    NSDate *datenow = [NSDate date];//现在时间
//    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
//    //    @"yy:MM:dd"
//    [dateFormatter setDateFormat:@"yyyy-MM-dd EEE"];
    
    NSDate *Date = [NSDate date];
    NSDate *lastDay = [NSDate dateWithTimeInterval:dayFloat sinceDate:Date];//前一天
    
    NSDateFormatter *birthformatter1 = [[NSDateFormatter alloc] init];
    birthformatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter1.dateFormat = @"yyyy-MM-dd EEE";
    
    NSString*dateTime =[birthformatter1 stringFromDate:lastDay];
    
    
    return dateTime;
    
}


//时间戳  格式化
+(NSString*)TimeWholeFormat:(NSString*)str{
    //这个是 北京时区
    NSDate*Strdate=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[str intValue]];
//    //得到当前时区
//    NSTimeZone * zone = [NSTimeZone systemTimeZone];
//    //当前时区和国际时区差了多少秒  28800秒
//    NSInteger interval = [zone secondsFromGMTForDate:Strdate];
//    //得到伦敦时区的时间
//    NSDate*londonDate=[Strdate dateByAddingTimeInterval:-interval];
    
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //    @"yy:MM:dd"
    [dateFormatter setDateFormat:@"yy:MM:dd--HH:mm:ss"];
    NSString*getTimer=[dateFormatter stringFromDate:Strdate];

    
    return getTimer;

    
}


//传一个时间 转化为00：00：00
+(NSString*)TimeHourFormat:(NSString*)str{
    //这个是 北京时区
    NSDate*Strdate=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[str intValue]];
////得到当前时区
//    NSTimeZone * zone = [NSTimeZone systemTimeZone];
////当前时区和国际时区差了多少秒  28800秒
//    NSInteger interval = [zone secondsFromGMTForDate:Strdate];
// //得到伦敦时区的时间
//    NSDate*londonDate=[Strdate dateByAddingTimeInterval:-interval];

    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    @"yy:MM:dd"
    [dateFormatter setDateFormat:@" HH:mm:ss"];
    NSString*getTimer=[dateFormatter stringFromDate:Strdate];
    
    
    
    return getTimer;
}

//传一个时间 转化为 17：05：02
+(NSString*)TimeYearFormat:(NSString*)str{
     NSDate*Strdate=[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[str intValue]];
//    //得到当前时区
//    NSTimeZone * zone = [NSTimeZone systemTimeZone];
//    //当前时区和国际时区差了多少秒  28800秒
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    //得到伦敦时区
//    NSDate*londonDate=[date dateByAddingTimeInterval:-interval];

    
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yy:MM:dd"];
    NSString*getTimer=[dateFormatter stringFromDate:Strdate];
    
    return getTimer;

}


//得到前一天的时间
+(NSString*)getProjectYesterdayTime{
    NSDate *Date = [NSDate date];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:Date];//前一天
    
    NSDateFormatter *birthformatter1 = [[NSDateFormatter alloc] init];
    birthformatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter1.dateFormat = @"yyyy-MM-dd";
    
   NSString*dateTime =[birthformatter1 stringFromDate:lastDay];
    
    dateTime=[NSString stringWithFormat:@"%@ 00:00:00",dateTime];
    NSLog(@"%@",dateTime);

    return dateTime;
}


//传入时间和 延后的天数 再得到时间   yyyy-MM-dd HH:mm:ss 时间
+(NSString*)TimeCurrentTime:(NSString*)currentTime andlaterDay:(NSInteger)dayIndex{
    NSDateFormatter*fformatter=[[NSDateFormatter alloc]init];
    fformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fformatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate*date=[fformatter dateFromString:currentTime];
    
    NSTimeInterval oneDay=1*24*60*60;
    NSTimeInterval interval=dayIndex*oneDay;
    NSDate*resultDate=[date initWithTimeIntervalSinceNow:interval];
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*TimerStr=[formatter stringFromDate:resultDate];
   

    return TimerStr;
    
}


//传入格式和str=@"yyyy-MM-dd" 得到date
+(NSDate*)TimeGetDateStr:(NSString*)timeStr andFormatterType:(NSString*)formatterType{
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat=formatterType;
    NSDate*date=[formatter dateFromString:timeStr];
    
    return date;
}



+(NSString *)GetRandomChar{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 10; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}


@end
