//
//  DateViewWithHourMonth.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateViewWithHourMinuteDelegate <NSObject>
@optional
- (void)selectTimeBack:(NSString *)timeStr;
@end

@interface DateViewWithHourMinute : UIView

/** 代理*/
@property (nonatomic, weak) id<DateViewWithHourMinuteDelegate> delegate;
@end
