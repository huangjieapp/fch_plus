//
//  MJKYJTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/7/14.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKYJTableViewCell.h"
#import "MJKHomePageJXModel.h"

@interface MJKYJTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *C_LOCNAME;
@property (weak, nonatomic) IBOutlet UILabel *C_OWNER_ROLENAME;
@property (weak, nonatomic) IBOutlet UILabel *MB;
@property (weak, nonatomic) IBOutlet UILabel *WC;
@property (weak, nonatomic) IBOutlet UILabel *WCL;
@end

@implementation MJKYJTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKHomePageJXModel *)model {
    _model = model;
    self.C_LOCNAME.text = model.C_LOCNAME;
    self.C_OWNER_ROLENAME.text = model.C_OWNER_ROLENAME;
    self.MB.text = model.MB;
    self.WC.text = model.WC;
    self.WCL.text = model.WCL;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKYJTableViewCell";
    MJKYJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
    
}
@end
