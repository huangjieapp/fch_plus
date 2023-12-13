//
//  MJKProductShowDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/3.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKProductShowModel;
NS_ASSUME_NONNULL_BEGIN

@interface MJKProductShowDetailTableViewCell : UITableViewCell
/** MJKProductShowModel*/
@property (nonatomic, strong) MJKProductShowModel *model;
/** <#注释#>*/
@property (nonatomic, assign) BOOL isNoPrice;
/** <#注释#>*/
@property (nonatomic, weak) UIViewController *rootVC;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
