//
//  MJKChooseEmployeesTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/5.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKChooseEmployeesModel;
@class MJKChooseEmployeesSubModel;
@class MJKClueListSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseEmployeesTableViewCell : UITableViewCell
/** MJKChooseEmployeesModel*/
@property (nonatomic, strong) MJKChooseEmployeesModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) NSString *vcName;
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseEmployeesBlock)(MJKClueListSubModel *model);
+ (CGFloat)cellForHeight:(MJKChooseEmployeesModel *)model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
