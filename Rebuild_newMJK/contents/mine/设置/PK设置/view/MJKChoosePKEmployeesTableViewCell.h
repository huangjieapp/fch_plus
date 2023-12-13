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
@class MJKPKModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKChoosePKEmployeesTableViewCell : UITableViewCell
/** MJKChooseEmployeesModel*/
@property (nonatomic, strong) MJKChooseEmployeesModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseEmployeesBlock)(MJKClueListSubModel *model);
+ (CGFloat)cellForHeight:(MJKChooseEmployeesModel *)model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) MJKPKModel *PKModel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_ID;
@end

NS_ASSUME_NONNULL_END
