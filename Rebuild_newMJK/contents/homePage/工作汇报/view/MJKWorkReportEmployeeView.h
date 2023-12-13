//
//  MJKWorkReportEmployeeView.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKWorkReportListModel.h"
#import "LTSCalendarManager.h"

@interface MJKWorkReportEmployeeView : UIView
@property (weak, nonatomic) IBOutlet UIView *noReportView;
@property (weak, nonatomic) IBOutlet UILabel *zrLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLaebl;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
/** 休假*/
@property (nonatomic, strong) NSArray *vacationArr;
//@property (nonatomic,strong) LTSCalendarManager *calendar;//日历
/** model*/
@property (nonatomic, strong) MJKWorkReportListModel *model;
/** 哪一个页面*/
@property (nonatomic, strong) NSString *vcName;
/** 返回的写过汇报的*/
@property (nonatomic, strong) NSArray *dotArray;
/** 创建时间*/
@property (nonatomic, strong) NSString *createTime;
/** 返回日期*/
@property (nonatomic, copy) void(^dateBlock)(NSString *dateStr);

/** 选择日期*/
@property (nonatomic, copy) void(^didSelectDateBlock)(NSString *dateStr);
/** 编辑*/
@property (nonatomic, copy) void(^editBlock)(void);
@end
