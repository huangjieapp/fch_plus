//
//  MJKSaleCarSourceTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/19.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSaleCarSourceTableViewCell.h"
#import "MJKProductShowModel.h"

@interface MJKSaleCarSourceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation MJKSaleCarSourceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKProductShowModel *)model {
    _model = model;
    [self.carImageView sd_setImageWithURL:[NSURL URLWithString:model.X_FMPICURL]];
    self.nameLabel.text = model.C_NAME;
}

static MJKProductShowModel *preModel;
static UIImageView *preSelectImageView;
- (IBAction)selectButtonAction:(UIButton *)sender {
    self.model.selected = !self.model.isSelected;
    if (preModel != nil) {
        preModel.selected = NO;
        preSelectImageView.image = [UIImage imageNamed:preModel.isSelected == YES ? @"选中" : @"未选中"];
    }
    self.selectImageView.image = [UIImage imageNamed:self.model.isSelected == YES ? @"选中" : @"未选中"];
    
    preModel = self.model;
    preSelectImageView = self.selectImageView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKSaleCarSourceTableViewCell";
    MJKSaleCarSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

@end
