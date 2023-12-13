//
//  CGCPersonInfoCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCPersonInfoCell.h"
#import "CGCPersonDetailInfoModel.h"

@implementation CGCPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCPersonInfoCell";
    CGCPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)reloadCell:(CGCPersonDetailInfoModel *)model withIndex:(NSInteger)index{
//,@"所属上级"
    NSArray * arr=@[@"账号",@"职位",@"手机",@"E-mail",@"微信号"];
    arr.count>index?self.leftLab.text=arr[index]:0;

    if (index==0) {
        self.rightLab.text=model.C_ACCOUNTNAME;
    }
    if (index==1) {
        self.rightLab.text=model.C_POSITION;
    }
    if (index==2) {
        self.rightLab.text=model.C_PHONENUMBER;
    }
   
    if (index==3) {
        self.rightLab.text=model.C_EMAILADDRESS;
    }
    if (index==4) {
        self.rightLab.text=model.C_WECHAT;
    }
//    if (index==5) {
//        self.rightLab.text=model.C_FATHERNAME;
//    }
    

}
@end
