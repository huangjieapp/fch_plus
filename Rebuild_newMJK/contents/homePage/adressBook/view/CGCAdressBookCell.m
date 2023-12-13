//
//  CGCAdressBookCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAdressBookCell.h"
#import "CGCAdressBookDetailModel.h"

@implementation CGCAdressBookCell

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


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CGCAdressBookCell";
    CGCAdressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)reloadCell:(CGCAdressBookDetailModel *)model{

    [self.img sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            self.iconLab.text=[model.C_NAME substringToIndex:1];
        }
    }];
    

    self.nameLab.text=model.C_NAME;
   
    if (model.C_HEADIMGURL.length==0) {
       
    }

}
@end
