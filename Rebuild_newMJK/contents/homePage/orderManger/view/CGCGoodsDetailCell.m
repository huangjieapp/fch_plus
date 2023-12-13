//
//  CGCGoodsDetailCell.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCGoodsDetailCell.h"
#import "CodeShoppingModel.h"

@implementation CGCGoodsDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCGoodsDetailCell";
    CGCGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)reloadCellWithModel:(CodeShoppingModel *)model{
    self.numLab.text=model.C_PRODUCTCODE;
    self.proLab.text=model.C_A41900_C_NAME;
    self.priceLab.text=model.B_PRICE;
    self.geshuLab.text=((model.I_NUMBER.length>0)?model.I_NUMBER:@"1");
}

@end
