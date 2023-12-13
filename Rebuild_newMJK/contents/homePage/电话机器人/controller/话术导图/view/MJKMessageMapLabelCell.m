//
//  MJKMessageMapLabelCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKMessageMapLabelCell.h"

@interface MJKMessageMapLabelCell  ()
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

@implementation MJKMessageMapLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addButtonAction:(UIButton *)sender {
    if (self.addButtonActionBlock) {
        self.addButtonActionBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKMessageMapLabelCell";
    MJKMessageMapLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
