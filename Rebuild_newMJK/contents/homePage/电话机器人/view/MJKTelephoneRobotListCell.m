//
//  MJKTelephoneRobotListCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotListCell.h"

#import "MJKTelephoneRobotModel.h"

@interface MJKTelephoneRobotListCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordArtLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation MJKTelephoneRobotListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKTelephoneRobotModel *)model {
    _model = model;
    self.nameLabel.text = model.C_OWNER_ROLENAME;
    self.timeLabel.text = model.D_START_TIME.length > 0 ? [model.D_START_TIME substringFromIndex:11] : @"";
    self.wordArtLabel.text = model.nlpEventName;
    self.statusLabel.text = model.C_STATUS_DD_NAME;
    self.titleLabel.text = model.C_NAME;
    if (model.I_NUMBER.length > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%@个",model.I_NUMBER];
    }
    if ([model.C_STATUS_DD_ID isEqualToString:@"A70100_C_STATUS_0000"]) {
        self.statusLabel.textColor = [UIColor redColor];//红
    } else if ([model.C_STATUS_DD_ID isEqualToString:@"A70100_C_STATUS_0001"]) {
        self.statusLabel.textColor = [UIColor colorWithHex:@"#FFC300"];//黄
    } else {
        self.statusLabel.textColor = [UIColor colorWithHex:@"#999999"];//灰
    }
}

- (void)setResultModel:(MJKTelephoneRobotModel *)resultModel {
    _resultModel = resultModel;
    self.titleLabel.text = resultModel.C_NAME;
    self.timeLabel.text = resultModel.number;
    if ([resultModel.C_STATUS_DD_ID isEqualToString:@"A70200_C_STATUS_0002"]) {
        self.wordArtLabel.text = resultModel.daStr;
    } else {
        self.wordArtLabel.text = [NSString stringWithFormat:@"%@  %@",resultModel.intentionDesc,resultModel.bill];
    }
    
    self.nameLabel.text = resultModel.C_OWNER_ROLENAME;
    self.statusLabel.text = resultModel.C_STATUS_DD_NAME;
    self.countLabel.hidden = YES;
    
    if ([resultModel.C_STATUS_DD_ID isEqualToString:@"A70200_C_STATUS_0002"]) {
        self.statusLabel.textColor = [UIColor redColor];//红
    } else if ([resultModel.C_STATUS_DD_ID isEqualToString:@"A70200_C_STATUS_0001"]) {
        self.statusLabel.textColor = [UIColor colorWithHex:@"#FFC300"];//黄
    } else {
        self.statusLabel.textColor = [UIColor colorWithHex:@"#999999"];//灰
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTelephoneRobotListCell";
    MJKTelephoneRobotListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
