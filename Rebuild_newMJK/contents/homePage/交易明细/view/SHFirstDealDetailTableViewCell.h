//
//  SHFirstDealDetailTableViewCell.h
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/15.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SHFirstSubSubModel.h"
#import "SHFirstDealSubModel.h"


@interface SHFirstDealDetailTableViewCell : UITableViewCell

//强制修改过的交易记录  金额和笔数用红色
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property(nonatomic,strong)SHFirstDealSubModel*model;

@end
