//
//  MJKTaskClockTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/2/22.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKTaskClockTableViewCell.h"
#import "MJKTaskClockModel.h"

@interface MJKTaskClockTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *xremarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation MJKTaskClockTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKTaskClockModel *)model {
    _model = model;
    self.nameLabel.text = model.C_TYPE_DD_NAME;
    self.statusLabel.text = model.C_STATUS_DD_NAME;
    self.xremarkLabel.text = model.X_REMARK;
    self.ownLabel.text = model.C_OWNER_ROLENAME;
    if ([model.C_STATUS_DD_ID isEqualToString:@"A46400_C_STATUS_0000"]) {
        self.statusLabel.textColor=DBColor(252,126,111);
    }else if ([model.C_STATUS_DD_ID isEqualToString:@"A46400_C_STATUS_0001"]){
        self.statusLabel.textColor=DBColor(75,176,196);
    }else{
        self.statusLabel.textColor=DBColor(153,153,153);
    }
}

- (void)setCheckModel:(MJKTaskClockModel *)checkModel {
    _checkModel = checkModel;
    self.nameLabel.text = checkModel.C_TYPE_DD_NAME;
    self.statusLabel.text = checkModel.C_BHGYY_DD_NAME;
    self.xremarkLabel.text = checkModel.X_REMARK;
//    self.ownLabel.text = checkModel.C_OWNER_ROLENAME;
    self.ownLabel.hidden = YES;
    if ([checkModel.C_STATUS_DD_ID isEqualToString:@"A72800_C_BHGYY_0000"]) {
        self.statusLabel.textColor=DBColor(252,126,111);
    }else if ([checkModel.C_STATUS_DD_ID isEqualToString:@"A72800_C_BHGYY_0001"]){
        self.statusLabel.textColor=DBColor(75,176,196);
    }else{
        self.statusLabel.textColor=DBColor(153,153,153);
    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTaskClockTableViewCell";
    MJKTaskClockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
