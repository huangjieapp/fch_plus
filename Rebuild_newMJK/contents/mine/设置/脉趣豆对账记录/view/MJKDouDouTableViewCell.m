//
//  MJKDouDouTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKDouDouTableViewCell.h"
#import "MJKRedPackageModel.h"

@implementation MJKDouDouTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKRedPackageModel *)model {
    _model = model;
    self.timeLabel.text = model.D_TRADESUCCESS_TIME;
    self.nameLabel.text = model.C_NAME;
    self.typeLabel.text = model.C_TYPE_DD_NAME;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"豆量\n%@",model.B_YUE]];
    [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#99b5fa"]} range:NSMakeRange([@"豆量\n" length], model.B_YUE.length)];
    self.doudouLabel.attributedText = attStr;
    
    NSMutableAttributedString *attJStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@%@",model.contentStr,model.flagStr,model.B_SJJE]];
    [attJStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#f8c859"],NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:14.f]} range:NSMakeRange([[NSString stringWithFormat:@"%@\n%@",model.contentStr,model.flagStr] length], model.B_SJJE.length)];
    self.jiangLabel.attributedText = attJStr;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKDouDouTableViewCell";
    MJKDouDouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
