//
//  MJKMaterialListType0TableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/9/16.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKMaterialListTypeTableViewCell.h"
#import "MJKMaterialListModel.h"

@interface MJKMaterialListTypeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightLayout;

@end

@implementation MJKMaterialListTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setModel:(MJKMaterialListModel *)model {
    _model = model;
    if ([model.type isEqualToString:@"2"]) {
        self.statusButton.hidden = NO;
        [self.statusButton setTitle:model.broadcastStr forState:UIControlStateNormal];
        if ([model.broadcastType isEqualToString:@"0"]) {
            [self.statusButton setBackgroundColor:[UIColor colorWithHex:@"#f9bd19"]];
        } else if ([model.broadcastType isEqualToString:@"2"]) {
            [self.statusButton setBackgroundColor:[UIColor colorWithHex:@"#929292"]];
        } else {
            [self.statusButton setBackgroundColor:[UIColor colorWithHex:@"#fd0315"]];
        }
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.salespicture]];
    self.nameLabel.text = model.salesname;
    NSString *str = model.title;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    self.contentLabel.text = str;
    CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if (height > 20) {
        self.contentLabelHeightLayout.constant = height + 10;
    }
    self.timeLabel.text = model.time;
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:model.fxpicurl]];
}
- (IBAction)shareButtonAction:(UIButton *)sender {
    if (self.shareButtonActionBlock) {
        self.shareButtonActionBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKMaterialListTypeTableViewCell";
    MJKMaterialListTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

+ (CGFloat)heightForCellWithModel:(MJKMaterialListModel *)model {
    NSString *str = model.title;
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    CGFloat height = [str boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if (height > 20) {
        return 310 + height;
    }
    return 330;
}

@end
