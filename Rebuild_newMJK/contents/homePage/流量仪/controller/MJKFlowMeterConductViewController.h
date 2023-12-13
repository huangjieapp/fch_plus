//
//  MJKFlowMeterConductViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/11.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowMeterDetailModel.h"

@interface MJKFlowMeterConductViewController : DBBaseViewController
@property (nonatomic, strong) MJKFlowMeterDetailModel *flowMeterModel;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) NSString *meterID;
@property (nonatomic, strong) NSArray *chooseArray;
@property (nonatomic, strong) NSArray *headImageArray;
@property (nonatomic, strong) NSString *isVip;//vip处理只有确定按钮



@property(nonatomic,assign)UIViewController*popVC;  //左上角的返回按钮返回到  这个vc
@end
