//
//  MJKYJTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/7/14.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKHomePageJXModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKYJTableViewCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) MJKHomePageJXModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
