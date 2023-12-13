//
//  ScaleView.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerDetailPathDetailModel.h"
#import "WorkCalendarModel.h"

@interface ScaleView : UIView

+(instancetype)scaleViewWithModel:(CustomerDetailPathDetailModel*)mainModel;

//这个是签到的放大
+(instancetype)ScaleSignWithModel:(WorkCalendarModel*)mainModel;

//付款记录放大  文字放大
+(instancetype)ScaleStringWith:(NSString*)textStr;

@end
