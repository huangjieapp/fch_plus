//
//  MJKWorkWorldSignCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKWorkWorldSignCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightArrow;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
