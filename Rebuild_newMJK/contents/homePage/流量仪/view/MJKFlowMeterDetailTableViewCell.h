//
//  MJKFlowMeterDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/10.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKFlowMeterDetailModel.h"

@interface MJKFlowMeterDetailTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sepLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeftLayout;
@property (weak, nonatomic) IBOutlet UIImageView *toCustomerImageView;
@property (nonatomic, copy) void(^toCustomerBlock)(void);

- (void)updataCellWithTitleArray:(NSArray *)titleArr andContent:(NSArray *)contentArr andIndexPath:(NSIndexPath *)indexPath;
@end
