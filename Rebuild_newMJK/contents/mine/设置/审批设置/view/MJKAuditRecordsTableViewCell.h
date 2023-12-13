//
//  MJKAuditRecordsTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKAuditRecordsModel;
NS_ASSUME_NONNULL_BEGIN

@interface MJKAuditRecordsTableViewCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) MJKAuditRecordsModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
