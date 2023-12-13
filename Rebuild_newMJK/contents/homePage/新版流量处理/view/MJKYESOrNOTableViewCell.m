//
//  MJKYESOrNOTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/4.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKYESOrNOTableViewCell.h"

@implementation MJKYESOrNOTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)yesButtonActioon:(UIButton *)sender {
    [self.noBUtton setBackgroundColor:kBackgroundColor];
    [sender setBackgroundColor:KNaviColor];
    if (self.yesButtonActionBlock) {
        self.yesButtonActionBlock();
    }
}
- (IBAction)noButtonAction:(UIButton *)sender {
    [self.yesButton setBackgroundColor:kBackgroundColor];
    [sender setBackgroundColor:KNaviColor];
    if (self.noButtonActionBlock) {
        self.noButtonActionBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKYESOrNOTableViewCell";
    MJKYESOrNOTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
