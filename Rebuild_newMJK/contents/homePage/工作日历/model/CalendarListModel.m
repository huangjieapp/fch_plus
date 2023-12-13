//
//  CalendarListModel.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CalendarListModel.h"
#import "WorkCalendarModel.h"

@implementation CalendarListModel
+ (nullable NSDictionary<NSString *, id
   > *)modelContainerPropertyGenericClass{
    
    return @{@"array":WorkCalendarModel.class,@"content":WorkCalendarModel.class}
    ;
    
}


@end
