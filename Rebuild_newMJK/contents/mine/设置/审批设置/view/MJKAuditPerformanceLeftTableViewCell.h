//
//  MJKAuditPerformanceLeftTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKAuditPerformanceLeftTableViewCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArr;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
