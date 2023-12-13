//
//  MJKFunnelMoreViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/13.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFunnelChooseModel.h"

@interface MJKFunnelMoreViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** MJKFunnelChooseModel*/
@property (nonatomic, strong) MJKFunnelChooseModel *model;
@end
