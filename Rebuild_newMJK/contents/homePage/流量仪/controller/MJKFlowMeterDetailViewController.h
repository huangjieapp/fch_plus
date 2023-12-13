//
//  MJKFlowMeterDetailViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowMeterSubSecondModel.h"

@interface MJKFlowMeterDetailViewController : UIViewController
@property (nonatomic, strong) MJKFlowMeterSubSecondModel *model;
@property (nonatomic, strong) NSString *VCName;
@property (nonatomic, strong) UIViewController *rootVC;
@property(nonatomic,weak)UIViewController*flowMachineListVC;
@end
