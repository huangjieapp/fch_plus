//
//  MJKReportDataTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/11/29.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKReportDataYearTableViewCell.h"
#import "MJReportDataModel.h"

@interface MJKReportDataYearTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *riXsLabel;
@property (weak, nonatomic) IBOutlet UILabel *riXxlabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidthLayout;

@end

@implementation MJKReportDataYearTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.firstWidthLayout.constant = KScreenWidth / 3;
}

- (void)setModel:(MJReportDataModel *)model {
    _model = model;
    self.nameLabel.text = model.C_NAME;
    if ([self.titleStr isEqualToString:@"线索"]) {
        self.riXsLabel.text = [NSString stringWithFormat:@"%@/%@",model.xs_nian_xs_xsl,model.xs_nian_xs_yx];
        self.riXxlabel.text = [NSString stringWithFormat:@"%@/%@",model.xs_nian_xx_xsl,model.xs_nian_xx_yx];
    } else if ([self.titleStr isEqualToString:@"预约"]) {
        self.riXsLabel.text = model.yy_nian_xs;
        self.riXxlabel.text = model.yy_nian_xx;
    } else if ([self.titleStr isEqualToString:@"订单"]) {
        self.riXsLabel.text = model.dd_nian_xs;
        self.riXxlabel.text = model.dd_nian_xx;
    } else if ([self.titleStr isEqualToString:@"全款"]) {
        self.riXsLabel.text = model.qk_nian_xs;
        self.riXxlabel.text = model.qk_nian_xx;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKReportDataYearTableViewCell";
    MJKReportDataYearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
    
}
@end
