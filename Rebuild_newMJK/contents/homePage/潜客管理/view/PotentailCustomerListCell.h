//
//  PotentailCustomerListCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PotentailCustomerListDetailModel.h"
#import "MJKCustomerSeaSubModel.h"
#import "MJKOldCustomerSalesModel.h"

@interface PotentailCustomerListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLayout;

/** <#注释#> */
@property (nonatomic,strong) MJKOldCustomerSalesModel *afterModel;

@property(nonatomic,strong)PotentailCustomerListDetailModel*detailModel;
@property(nonatomic,strong)MJKCustomerSeaSubModel*seaModel;
@property(nonatomic,assign)BOOL isNewAssign;  //是否是重新指派


//最后一个cell 需要撑满
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomVIewLeftValue;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
