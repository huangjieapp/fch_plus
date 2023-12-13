//
//  MJKCcApprovalTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2022/3/4.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKMessageDetailModel;
@class MJKApprovalHistoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCcApprovalTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic,strong) MJKMessageDetailModel *model;
/** <#注释#> */
@property (nonatomic,strong) MJKApprovalHistoryModel *ahModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
