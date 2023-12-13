//
//  MJKCcApprovalTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2022/3/4.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCcApprovalTableViewCell.h"
#import "MJKMessageDetailModel.h"
#import "MJKApprovalHistoryModel.h"

@interface MJKCcApprovalTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation MJKCcApprovalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKMessageDetailModel *)model {
    _model = model;
    self.headerImageView.image = [UIImage imageNamed:@"logo-images"];
    self.statusLabel.text = model.C_STATE_DD_NAME;
    self.nameLabel.text = model.C_TITLE_NAME;
    self.timeLabel.text = model.D_CREATE_TIME;
    self.contentLabel.text = model.X_CONTENT;
    
}

- (void)setAhModel:(MJKApprovalHistoryModel *)ahModel {
    _ahModel = ahModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:ahModel.avatar] placeholderImage:[UIImage imageNamed:@"logo-images"]];
    self.statusLabel.text = ahModel.C_STATUS_DD_NAME;
    self.nameLabel.text = ahModel.C_APPROVAL_NAME;
    self.timeLabel.text = ahModel.D_LASTUPDATE_TIME;
    self.contentLabel.text = ahModel.X_REMARK;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKCcApprovalTableViewCell";
    MJKCcApprovalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, KScreenWidth);
    }
    return cell;
    
}

@end
