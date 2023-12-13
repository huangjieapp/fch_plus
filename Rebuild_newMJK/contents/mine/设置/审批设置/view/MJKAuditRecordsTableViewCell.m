//
//  MJKAuditRecordsTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAuditRecordsTableViewCell.h"
#import "MJKAuditRecordsModel.h"

@interface MJKAuditRecordsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation MJKAuditRecordsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKAuditRecordsModel *)model {
    _model = model;
    self.nameLabel.text = model.C_APPROVAL_NAME;
    self.statusLabel.text = model.C_STATUS_DD_NAME;
    self.timeLabel.text = model.D_LASTUPDATE_TIME;
    self.remarkLabel.text = model.X_AGREE;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAuditRecordsTableViewCell";
    MJKAuditRecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
