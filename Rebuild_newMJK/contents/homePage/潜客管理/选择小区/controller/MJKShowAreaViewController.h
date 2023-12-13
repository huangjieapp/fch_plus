//
//  MJKShowAreaViewController.h
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKShowAreaModel;

@interface MJKShowAreaViewController : UIViewController
@property (nonatomic, copy) void(^selectAddressBlock)(MJKShowAreaModel *model);
@end
