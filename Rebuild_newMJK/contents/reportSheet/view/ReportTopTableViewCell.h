//
//  ReportTopTableViewCell.h
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/5.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportSheetModel.h"

@interface ReportTopTableViewCell : UITableViewCell

@property(nonatomic,strong)ReportSheetModel*mainModel;
-(void)getValue:(ReportSheetModel*)mainModel;


@end
