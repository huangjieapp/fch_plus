//
//  MJKWorkReportListCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/6/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKWorkReportListModel.h"
#import "MJKWorkReportDetailModel.h"

@interface MJKWorkReportListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** 父控制器*/
@property (nonatomic, weak) UIViewController *rootVC;
/** listModel*/
@property (nonatomic, strong) MJKWorkReportListModel *listModel;
/** 点赞*/
@property (nonatomic, copy) void(^praiseBlock)(BOOL isSelected);
/** 评论*/
@property (nonatomic, copy) void(^commentsBlock)(void);
/** 返回cell高度*/
@property (nonatomic, copy) void(^backCellHeightBlock)(NSInteger cellHeight);
/** 点击个人*/
@property (nonatomic, copy) void(^didSelectPersonalBlock)(void);
/** cell array*/
@property (nonatomic, strong)  NSArray *cellArray;
@end
