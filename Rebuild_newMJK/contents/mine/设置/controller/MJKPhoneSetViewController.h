//
//  MJKPhoneSetViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/14.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKPhoneSetListSubModel.h"

@interface MJKPhoneSetViewController : UIViewController
@property (nonatomic, strong) MJKPhoneSetListSubModel *phoneModel;

#warning 没有任何地方 给过titleStr 赋值过   不可能走 [self.titleStr isEqualToString:@"电话分配设置"]
@property (nonatomic, strong) NSString *titleStr;//为电话分配设置时是添加状态
@end


#pragma 电话分配设置    还有nil
