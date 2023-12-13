//
//  CGCAlreadyPayCell.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAlreadyPayCell.h"
#import "CGCAlreadyPayModel.h"


@implementation CGCAlreadyPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius=4.0;
    self.bgView.layer.masksToBounds=YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCAlreadyPayCell";
    CGCAlreadyPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)reloadCellWithModel:(CGCAlreadyPayModel *)model{


    self.countLab.text=model.AMOUNT;
    self.desLab.text=model.X_REMARK;
    self.dateLab.text=model.D_CREATE_TIME;
    if ([model.C_PAYCHANNEL isEqualToString:@"wx"]) {
        self.iconImg.image=[UIImage imageNamed:@"click_wechatbright"];
    }
    if ([model.C_PAYCHANNEL isEqualToString:@"ali"]) {
        self.iconImg.image=[UIImage imageNamed:@"click_paybright"];
    }
    if ([model.C_PAYCHANNEL isEqualToString:@"xj"]) {
        self.iconImg.image=[UIImage imageNamed:@"click_moneybright"];
    }
    if ([model.C_PAYCHANNEL isEqualToString:@"sk"]) {
        self.iconImg.image=[UIImage imageNamed:@"click_xinyongbright"];
    }
}

@end
