//
//  ReportTopTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportSheetModel.h"

@interface ReportTopTableViewCellNoGroup_bak : UITableViewCell

@property(nonatomic,strong)ReportSheetModel*mainModel;
/** <#注释#> */
@property (nonatomic, copy)  void(^buttonClickBlock)(NSInteger tag);
/** <#备注#>*/
@property (nonatomic, weak) UIViewController *rootVC;
-(void)getValue:(ReportSheetModel*)mainModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
