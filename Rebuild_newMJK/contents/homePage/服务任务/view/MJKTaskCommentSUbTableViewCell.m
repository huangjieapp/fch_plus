//
//  MJKTaskCommentSUbTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTaskCommentSUbTableViewCell.h"
#import "MJKTaskCommentModel.h"

@implementation MJKTaskCommentSUbTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKTaskCommentModel *)model{
    _model = model;
    NSString *desStr = model.X_REMARK;
    if (self.model.X_REMINDING.length > 0) {
        desStr = [NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME]];
        [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#99b5fa"]} range:NSMakeRange([[NSString stringWithFormat:@"%@\n",model.X_REMARK] length], model.X_REMINDINGNAME.length)];
        self.desLabel.attributedText = attStr;
    } else {
        self.desLabel.text = model.X_REMARK;
    }
    self.timeLabel.text = model.D_CREATE_TIME;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTaskCommentSUbTableViewCell";
    MJKTaskCommentSUbTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kBackgroundColor;
    }
    return cell;
}
@end
