//
//  MJKExpandNewAddTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/4/13.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKExpandNewAddTableViewCell : UITableViewCell
/** <#备注#>*/
@property (nonatomic, copy) void(^buttonAcrionBlock)(NSString *titleStr, BOOL isSelected);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
