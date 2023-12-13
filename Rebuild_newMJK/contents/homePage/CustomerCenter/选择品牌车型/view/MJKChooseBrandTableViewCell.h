//
//  MJKChooseBrandTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseBrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
