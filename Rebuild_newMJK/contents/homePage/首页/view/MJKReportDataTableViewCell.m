//
//  MJKReportDataTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/11/29.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKReportDataTableViewCell.h"
#import "MJReportDataModel.h"

@interface MJKReportDataTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *riXsLabel;
@property (weak, nonatomic) IBOutlet UILabel *riXxlabel;
@property (weak, nonatomic) IBOutlet UILabel *yueXsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yueXxLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidthLayout;

@end

@implementation MJKReportDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.firstWidthLayout.constant = KScreenWidth / 3;
}

- (void)setModel:(MJReportDataModel *)model {
    _model = model;
    self.nameLabel.text = model.C_NAME;
    if ([self.titleStr isEqualToString:@"线索"]) {
        self.riXsLabel.text = [NSString stringWithFormat:@"%@/%@",model.xs_ri_xs_xsl,model.xs_ri_xs_yx];
        self.riXxlabel.text = [NSString stringWithFormat:@"%@/%@",model.xs_ri_xx_xsl,model.xs_ri_xx_yx];
        self.yueXsLabel.text = [NSString stringWithFormat:@"%@/%@",model.xs_yue_xs_xsl,model.xs_yue_xs_yx];
        self.yueXxLabel.text = [NSString stringWithFormat:@"%@/%@",model.xs_yue_xx_xsl,model.xs_yue_xx_yx];
    } else if ([self.titleStr isEqualToString:@"预约"]) {
        self.riXsLabel.text = model.yy_ri_xs;
        self.riXxlabel.text = model.yy_ri_xx;
        self.yueXsLabel.text = model.yy_yue_xs;
        self.yueXxLabel.text = model.yy_yue_xx;
    } else if ([self.titleStr isEqualToString:@"销量"]) {
        self.riXsLabel.text = model.dd_ri_xs;
        self.riXxlabel.text = model.dd_ri_xx;
        self.yueXsLabel.text = model.dd_yue_xs;
        self.yueXxLabel.text = model.dd_yue_xx;
    } else if ([self.titleStr isEqualToString:@"潜客"]) {
        self.riXsLabel.text = model.qk_ri_xs;
        self.riXxlabel.text = model.qk_ri_xx;
        self.yueXsLabel.text = model.qk_yue_xs;
        self.yueXxLabel.text = model.qk_yue_xx;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKReportDataTableViewCell";
    MJKReportDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return cell;
    
}
@end
