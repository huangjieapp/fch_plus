//
//  MJKClueMarketTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKClueListSubModel.h"

@interface MJKClueMarketTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#备注#>*/
@property (nonatomic, copy) void(^chooseEmployeesBlock)(MJKClueListSubModel *model);
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (nonatomic, strong) MJKClueListSubModel *subModel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
/** <#注释#> */
@property (nonatomic, strong) NSString *vcName;

@end
