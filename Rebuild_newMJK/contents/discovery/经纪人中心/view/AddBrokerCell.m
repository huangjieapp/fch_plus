//
//  AddBrokerCell.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/18.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "AddBrokerCell.h"

@implementation AddBrokerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AddBrokerCell";
    AddBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    return cell;
    
}
@end
