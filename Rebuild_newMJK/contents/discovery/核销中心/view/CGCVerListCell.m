//
//  CGCVerListCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCVerListCell.h"
#import "PointorderModel.h"
#import "CGCCustomModel.h"

@implementation CGCVerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.img.layer.cornerRadius=4;
    self.img.layer.masksToBounds=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)verificationCellReloadCell:(PointorderModel *)model{

   
    self.nameLab.text=model.consumerName;
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.smallpicture]];
    
    [self.statusbtn setTitleNormal:model.status];
    self.desLab.text=model.name;
    self.storeLab.text=model.storename;
    if (model.smallpicture.length==0) {
        
        self.staLab.text=[model.name substringToIndex:1];
    }
}



-(void)brokerCellWithModel:(CGCCustomModel *)model{
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.C_PICURL] placeholderImage:nil];
    
    self.nameLab.text=model.C_NAME;
  
    if (model.C_WECHAT.length>0) {
        self.desLab.text=[NSString stringWithFormat:@"微信昵称:%@",model.C_WECHAT];
    }
    
     self.storeLab.text=[NSString stringWithFormat:@"积分:%@",model.I_INTEGRAL];
    
    [self.statusbtn setTitleNormal:model.C_STATUS_DD_NAME];

  
    if (model.C_PICURL.length==0) {
        if (model.C_NAME.length>0) {
            self.staLab.text=[model.C_NAME substringToIndex:1];
        }
       
    }
 
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCVerListCell";
    CGCVerListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
