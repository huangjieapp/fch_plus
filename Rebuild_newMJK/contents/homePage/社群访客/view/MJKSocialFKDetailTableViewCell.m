//
//  MJKSocialFKDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSocialFKDetailTableViewCell.h"
#import "MJKSocialFKModel.h"

@interface MJKSocialFKDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabe;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thridLabel;

@end

@implementation MJKSocialFKDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKSocialFKModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.faceurl]];
    self.nameLabe.text = model.name;
    self.firstLabel.text = model.allVisitorNumber;
    self.secondLabel.text = model.activeNumber;
    self.thridLabel.text = model.customerNumber;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKSocialFKDetailTableViewCell";
    MJKSocialFKDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
