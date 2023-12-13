//
//  CGCSelCustomCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCSelCustomCell.h"
#import "CGCSellModel.h"
@implementation CGCSelCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCSelCustomCell";
    CGCSelCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)reloadCellWithModel:(CGCSellModel *)model{
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
    self.nameLab.text=model.nickName;
    self.countLab.text=[NSString stringWithFormat:@"%@",@(model.COUNT)];
}
@end
