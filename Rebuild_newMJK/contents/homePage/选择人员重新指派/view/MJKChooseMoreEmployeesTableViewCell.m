//
//  MJKChooseMoreEmployeesTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseMoreEmployeesTableViewCell.h"

@implementation MJKChooseMoreEmployeesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
}

- (void)setSubModel:(MJKClueListSubModel *)subModel {
    _subModel = subModel;
    if (self.codeStr.length > 0) {
        NSArray *codeArr = [self.codeStr componentsSeparatedByString:@","];
        for (NSString *code in codeArr) {
            if ([code isEqualToString:subModel.user_id]) {
                subModel.selected = YES;
            }
        }
    }
    self.selectImageView.image = [UIImage imageNamed:subModel.isSelected == YES ? @"打钩.png" : @"未打钩"];
    if (subModel.C_HEADPIC.length > 0) {
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:subModel.C_HEADPIC]];
    } else {
        self.picImageView.image = [UIImage imageNamed:@"logo-2.png"];
    }
    self.nameLabel.text = subModel.user_name;
    
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    _subModel.selected = !_subModel.isSelected;
    self.selectImageView.image = [UIImage imageNamed:_subModel.isSelected == YES ? @"打钩.png" : @"未打钩"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKChooseMoreEmployeesTableViewCell";
    MJKChooseMoreEmployeesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
