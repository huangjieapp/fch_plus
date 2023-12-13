//
//  MJKCallShowDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCallShowDetailTableViewCell.h"
#import "MJKCallShowDetailModel.h"

@interface MJKCallShowDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@end

@implementation MJKCallShowDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKCallShowDetailModel *)model {
    _model = model;
    self.nameLabel.text = model.C_NAME;
    self.phoneLabel.text = model.C_PHONE;
    self.saleLabel.text = model.C_OWNER_ROLENAME;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKCallShowDetailTableViewCell";
    MJKCallShowDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
