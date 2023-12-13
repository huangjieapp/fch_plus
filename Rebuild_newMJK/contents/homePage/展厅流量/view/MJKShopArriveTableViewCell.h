//
//  MJKShopArriveTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKShopArriveContentModel.h"

typedef void(^BackModelBlock)(MJKShopArriveContentModel *model);

@interface MJKShopArriveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *seleteButton;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (nonatomic, strong) MJKShopArriveContentModel *model;
@property (nonatomic, copy) BackModelBlock backModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
