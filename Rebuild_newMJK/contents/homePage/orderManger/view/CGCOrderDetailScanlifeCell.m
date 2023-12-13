//
//  CGCOrderDetailScanlifeCell.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/21.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCOrderDetailScanlifeCell.h"//订单详情里的意向产品（扫二维码）

@implementation CGCOrderDetailScanlifeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(CGCOrderDetailScanlifeCellStyle)type{
    static NSString *ID = @"CGCOrderDetailScanlifeCell";
    CGCOrderDetailScanlifeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
       
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.bgView.layer.borderWidth=0.5;
        cell.bgView.layer.borderColor=KColorForAlert.CGColor;
        
        if (type == CGCOrderDetailScanlifeCellDisplay) {
            cell.textView.userInteractionEnabled=NO;
            cell.scanlifeBtn.hidden=YES;
        }else if(type == CGCOrderDetailScanlifeCellEidt){
            cell.textView.userInteractionEnabled=YES;
            cell.scanlifeBtn.hidden=NO;
        }
    }
    return cell;
    
}
@end
