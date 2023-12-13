//
//  MJKSetWorkTaskCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/29.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJKClueListSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKSetWorkTaskCell : UITableViewCell
/** 返回选中的userid*/
@property (nonatomic, copy) void(^backSelectBlock)(void);
/** MJKClueListSubModel*/
@property (nonatomic, strong) MJKClueListSubModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
