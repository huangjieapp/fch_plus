//
//  MJKTelephoneRoboCalltResultCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/6.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRoboCalltResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabelArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contentLabelArray;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
