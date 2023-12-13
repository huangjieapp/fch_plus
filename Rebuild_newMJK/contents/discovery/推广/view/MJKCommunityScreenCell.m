//
//  MJKCommunityScreenCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCommunityScreenCell.h"

#import "MJKShowAreaModel.h"

@implementation MJKCommunityScreenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKShowAreaModel *)model {
    _model = model;
    self.titleLabel.text = model.C_NAMEANDADDRESS;
    if (model.isSelected == YES) {
        [self.selectButton setImage:@"打钩"];
    } else {
        [self.selectButton setImage:@"未打钩"];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"MJKCommunityScreenCell";
    MJKCommunityScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
