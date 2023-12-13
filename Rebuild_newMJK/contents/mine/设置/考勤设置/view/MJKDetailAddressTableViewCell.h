//
//  MJKDetailAddressTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/6.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKCheckDetailAddressModel.h"

@interface MJKDetailAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
/** address dic*/
@property (nonatomic, strong) NSDictionary *dic;
/** <#备注#>*/
@property (nonatomic, strong) MJKCheckDetailAddressModel *addressModel;
/** 删除*/
@property (nonatomic, copy) void(^deleteAddressBlock)(void);
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
