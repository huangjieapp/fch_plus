//
//  MJKEmployeesAccountCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKEmployeesAccountCell.h"

#import "MJKEmployeesAccountModel.h"

@interface MJKEmployeesAccountCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *archLabel;

@end

@implementation MJKEmployeesAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKEmployeesAccountModel *)model {
    _model = model;
    self.nameLabel.text = model.C_NAME;
    self.accountLabel.text = model.C_ACCOUNTNAME;
    self.jobLabel.text = model.C_U00300_C_NAME;
    self.archLabel.text = model.C_U00100_C_NAME;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKEmployeesAccountCell";
    MJKEmployeesAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
