//
//  MJKPayDetailInfoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKPayDetailInfoTableViewCell.h"
#import "MJKPayModel.h"

@interface MJKPayDetailInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@end

@implementation MJKPayDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPayModel:(MJKPayModel *)payModel {
    _payModel = payModel;
    if ([self.chooseTabStr isEqualToString:@"收款明细"]) {
        NSString *timeStr = payModel.D_COLLECTION_TIME;
        if (payModel.D_COLLECTION_TIME.length > 10) {
            timeStr = [timeStr substringToIndex:10];
        }
        self.firstLabel.text = timeStr;
        self.secondLabel.text = payModel.AMOUNT;
        self.thirdLabel.text = payModel.C_TYPE_DD_NAME;
        self.fourthLabel.text = payModel.C_OWNER_ROLENAME;
    } else {
        self.firstLabel.text = payModel.username;
        self.secondLabel.text = payModel.MB;
        self.thirdLabel.text = payModel.SKCOUNT;
        self.fourthLabel.text = payModel.WCBL;
    }
    
}

#pragma mark - 注册
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKPayDetailInfoTableViewCell";
    MJKPayDetailInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
    
}

@end
