//
//  MJKPayTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKPayTableViewCell.h"
#import "MJKPayModel.h"

@interface MJKPayTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thridLabel;

@end

@implementation MJKPayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPayModel:(MJKPayModel *)payModel {
    _payModel = payModel;
    if ([self.chooseTabStr isEqualToString:@"目标进度"]) {
        self.firstLabel.text = payModel.dateTime;
    } else {
        self.firstLabel.text = payModel.username;
    }
    
    
    self.secondLabel.text = payModel.SKCOUNT;
    self.thridLabel.text = payModel.WCBL;
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKPayTableViewCell";
    MJKPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
    
}

@end
