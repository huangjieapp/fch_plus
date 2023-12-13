//
//  MJKPayDetailInfoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNewPayDetailInfoTableViewCell.h"
#import "MJKPayModel.h"

@interface MJKNewPayDetailInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@end

@implementation MJKNewPayDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPayModel:(MJKPayModel *)payModel {
    _payModel = payModel;
    if ([self.chooseTabStr isEqualToString:@"资源榜"]) {
        self.firstLabel.text = payModel.NAME;
    } else {
        self.firstLabel.text = payModel.C_OWNER_ROLENAME;
    }
        self.secondLabel.text = payModel.num;
    
    
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKNewPayDetailInfoTableViewCell";
    MJKNewPayDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
    
}

@end
