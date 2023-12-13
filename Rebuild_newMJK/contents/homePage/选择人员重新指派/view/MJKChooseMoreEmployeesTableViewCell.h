//
//  MJKChooseMoreEmployeesTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueListSubModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MJKChooseMoreEmployeesTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseEmployeesBlock)(MJKClueListSubModel *model);
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (nonatomic, strong) MJKClueListSubModel *subModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *codeStr;
@end

NS_ASSUME_NONNULL_END
