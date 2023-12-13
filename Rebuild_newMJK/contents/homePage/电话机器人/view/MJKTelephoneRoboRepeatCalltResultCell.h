//
//  MJKTelephoneRoboRepeatCalltResultCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/6.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRoboRepeatCalltResultCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contentLabelArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabelArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
