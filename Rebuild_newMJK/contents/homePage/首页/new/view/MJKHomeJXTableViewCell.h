//
//  MJKHomeJXTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2022/1/14.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKHomeJXTableViewCell : UITableViewCell
/** <#注释#> */
@property (nonatomic,copy) void(^buttonActionBlock)(NSInteger tag);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
