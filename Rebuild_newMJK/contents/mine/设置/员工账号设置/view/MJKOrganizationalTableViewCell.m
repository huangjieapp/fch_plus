//
//  MJKOrganizationalTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKOrganizationalTableViewCell.h"

#import "MJKOrganizationalModel.h"

@interface MJKOrganizationalTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MJKOrganizationalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //icon_1_highlight
    
}

- (void)setModel:(MJKOrganizationalModel *)model {
    _model = model;
    self.titleLabel.text = model.C_U00100_C_NAME;
    self.selectImageView.image = [UIImage imageNamed:model.isSelected == YES ? @"icon_1_highlight" : @"未选中"];
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}
static MJKOrganizationalModel *perModel;
static UIImageView *perImageView;
- (IBAction)selectButtonAction:(UIButton *)sender {
    self.model.selected = !self.model.isSelected;
    self.selectImageView.image = [UIImage imageNamed:self.model.isSelected == YES ? @"icon_1_highlight" : @"未选中"];
    
    perModel.selected = NO;
    perImageView.image = [UIImage imageNamed:@"未选中"];
    
    perModel = self.model;
    perImageView = self.selectImageView;
    
    if (self.selectButtonBlock) {
        self.selectButtonBlock();
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKOrganizationalTableViewCell";
    MJKOrganizationalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
