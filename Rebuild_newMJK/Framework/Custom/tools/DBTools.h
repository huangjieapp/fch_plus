//
//  DBTools.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/19.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBTools : NSObject

//哈希算法
+ (NSString *)sha1:(NSString *)inputString;

//得到UUID
+(NSString *)getUUID;
+ (NSString *)uuid;
//得到view 的父视图控制器
+(UIViewController*)getSuperViewWithsubView:(UIView*)subView;
//得到第一响应者的view
+(UIView*)findFirstResponderBeneathView:(UIView*)view;

//传入金额， 给金额打上逗号 可以带.00
+(NSString*)addSeparatorForPriceString:(NSString*)priceStr;

#pragma 文件管理   广告栏需要
//计算文件的尺寸
+(CGFloat)folderSize;
//清除缓存
+ (void)removeCache;
//判断文件是否存在
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath;
//根据图片名拼接文件路径
+ (NSString *)getFilePathWithImageName:(NSString *)imageName;

//传入 秒 得到 xx:xx:xx

+(NSString *)getHHMMSSFromSS:(NSString *)totalTime;


//传入 秒 得到 xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;
+(NSString*)getTimeFomatFromCurrentTimeStampWithYMD;
+(NSString*)getTimeFomatFromTimeStampOnlyYMDAddDay:(NSInteger)day andNowTime:(NSString *)time;
+(NSString*)getBeforeTimeFomatFromTimeStampOnlyYMDAddDay:(NSInteger)day andNowTime:(NSString *)time;
#pragma 关于时间   这里要区分国际的还是北京的
+ (NSString *)getYearMonthTime;
//得到一个时间戳  是string类型
+(NSString *)getCurrentTimeStamp;
//得到年月日    yyyy-MM-dd
+(NSString*)getYearMonthDayTime;
//得到当前的时间点格式化好的了   @"yyyy-MM-dd HH:mm:ss"
+(NSString*)getTimeFomatFromCurrentTimeStamp;
//得到当前的时间点后三个小时格式化好的了   @"yyyy-MM-dd HH:mm:ss"
+(NSString*)getTimeFomatFromCurrentTimeStampAddThreeTime;
+(NSString*)getYearMonthDayTimeWithDate:(NSDate *)date;
+(NSString*)getTimeFomatFromTimeStampAddThreeTime:(NSString *)time;
+(NSString*)getTimeFomatFromTimeStampSubThreeTime:(NSString *)time;
+(NSString*)getWeeksFomatFromCurrentTimeStampWithDays:(NSTimeInterval)dayFloat;
//传入时间串  得到格式化之后  yy:MM:dd--HH:mm:ss
+(NSString*)TimeWholeFormat:(NSString*)str;
//传一个时间 转化为HH:mm:ss
+(NSString*)TimeHourFormat:(NSString*)str;
//传一个时间 转化为 yy:MM:dd
+(NSString*)TimeYearFormat:(NSString*)str;
//项目需要  得到昨天的时间
+(NSString*)getProjectYesterdayTime;
//传入时间和 延后的天数 再得到时间   yyyy-MM-dd HH:mm:ss 时间
+(NSString*)TimeCurrentTime:(NSString*)currentTime andlaterDay:(NSInteger)dayIndex;
//传入格式和str 得到date
+(NSDate*)TimeGetDateStr:(NSString*)timeStr andFormatterType:(NSString*)formatterType;
//得到当前的时间点格式化好的了   @"yyyy-MM-dd EEE"
+(NSString*)getWeeksTimeFomatFromCurrentTimeStamp;
+(NSString*)getWeeksFomatFromCurrentTimeStamp;
+(NSDate*)getYearMonthDayTimeWithStr:(NSString *)date;
+(NSString*)getTimeFomatFromTimeStampAddDay:(NSInteger)day;
+(NSString*)getTimeFomatFromTimeStampAddDay:(NSInteger)day andTime:(NSString *)time;

//随机数  没看懂返回什么值
+(NSString *)GetRandomChar;



#pragma mark - 创建button
+ (UIButton *)creatButtonWithFrame:(CGRect)frame Target:(id)target Sel:(SEL)method Title:(NSString *)title ImageName:(NSString *)imageName BGImageName:(NSString *)bgImageName;

#pragma mask 创建label
+ (UILabel *)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString *)text;

@end
