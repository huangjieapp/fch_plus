//
//  MJKBrokerCenterCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/29.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CGCCustomModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKBrokerCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftLayout;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
- (void)brokerCellWithModel:(CGCCustomModel *)model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
