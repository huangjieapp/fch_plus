//
//  MJKNewWorkReportCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNewWorkReportCell.h"
#import "MJKPKModel.h"

@interface MJKNewWorkReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation MJKNewWorkReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKPKModel *)model {
    _model = model;
    self.titleLabel.text = model.C_NAME;
    self.numLabel.text = model.PEOPLENUMBER;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKNewWorkReportCell";
    MJKNewWorkReportCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
