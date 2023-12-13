//
//  CGCOrderDetailOtherCell.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCOrderDetailModel.h"
#import "CGCOrderDetailOtherCell.h"//订单备注和已付金额


@implementation CGCOrderDetailOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.payView.hidden=YES;
//    self.paytitleView.hidden=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCellWith:(CGCOrderDetailModel *)model{

    self.remarkLab.text=model.X_REMARK;
    self.moneyLab.text=model.SumMoney;
    

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCOrderDetailOtherCell";
    CGCOrderDetailOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
      
    }
    return cell;
    
}


@end
