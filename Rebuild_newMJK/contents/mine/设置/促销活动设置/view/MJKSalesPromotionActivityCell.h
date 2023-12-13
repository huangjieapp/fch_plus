//
//  MJKSalesPromotionActivityCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/10.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKMarketSubModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJKSalesPromotionActivityCell : UITableViewCell
/** MJKMarketModel*/
@property (nonatomic, strong) MJKMarketSubModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
