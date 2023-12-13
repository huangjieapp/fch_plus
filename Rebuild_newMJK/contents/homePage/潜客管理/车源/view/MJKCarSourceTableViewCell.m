//
//  MJKCarSourceTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/16.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCarSourceTableViewCell.h"

#import "MJKCarSourceSubModel.h"

@interface MJKCarSourceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation MJKCarSourceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKCarSourceSubModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_BY_A49600_C_PICTURE]];
    self.carNameLabel.text = model.C_BY_A49600_C_NAME;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",model.C_XSCKJ];
    self.saleLabel.text = model.C_NAME;
}

- (IBAction)selectButtonAction:(UIButton *)sender {
    self.model.selected = !self.model.isSelected;
    self.selectImage.image = [UIImage imageNamed:self.model.isSelected == YES ? @"选中" : @"未选中"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKCarSourceTableViewCell";
    MJKCarSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
