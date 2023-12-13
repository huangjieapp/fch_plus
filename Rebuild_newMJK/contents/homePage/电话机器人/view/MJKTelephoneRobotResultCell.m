//
//  MJKTelephoneRobotResultCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotResultCell.h"
#import "MJKTelephoneRobotModel.h"


@interface MJKTelephoneRobotResultCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusWidth;
@end

@implementation MJKTelephoneRobotResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKTelephoneRobotModel *)model {
    _model = model;
    self.nameLabel.text = model.C_NAME;
    self.phoneLabel.text = model.number;
    self.statusLabel.text = model.C_STATUS_DD_NAME;
    self.timeLabel.text = model.bill;
    
    CGSize nameSize = [model.C_NAME boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    
    CGSize phoneSize = [model.number boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
    
    CGSize statusSize = [model.C_STATUS_DD_NAME boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
    
    self.nameWidth.constant = nameSize.width + 10;
    self.phoneWidth.constant = phoneSize.width + 10;
    self.statusWidth.constant = statusSize.width + 10;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTelephoneRobotResultCell";
    MJKTelephoneRobotResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
