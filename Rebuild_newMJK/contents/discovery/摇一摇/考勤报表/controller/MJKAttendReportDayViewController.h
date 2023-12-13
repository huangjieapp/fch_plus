//
//  MJKAttendReportDayViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKWorkReportStatementsListModel.h"

@interface MJKAttendReportDayViewController : UIViewController
/** <#备注#>*/
@property (nonatomic, strong) NSString *timeStr;
/** MJKWorkReportStatementsListModel*/
@property (nonatomic, strong) MJKWorkReportStatementsListModel *listModel;
@end
