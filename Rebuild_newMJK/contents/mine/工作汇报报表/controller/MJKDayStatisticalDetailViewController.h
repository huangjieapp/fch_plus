//
//  MJKDayStatisticalDetailViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKWorkReportStatementsListModel.h"

@interface MJKDayStatisticalDetailViewController : UIViewController
/** 时间*/
@property (nonatomic, strong) NSString *timeStr;
/** list model*/
@property (nonatomic, strong) MJKWorkReportStatementsListModel *listModel;
@end
