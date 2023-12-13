//
//  MJKSocialFKDetailShowTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/1/21.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKSocialFKDetailShowTableViewCell.h"
#import "MJKSocialFKModel.h"

@interface MJKSocialFKDetailShowTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@end

@implementation MJKSocialFKDetailShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKSocialFKModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.timeLabel.text = model.remark;
    self.fromLabel.text = [NSString stringWithFormat:@"%@ %@",model.createTime,model.source];
    self.saleLabel.text = model.salername;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"logo-2"]];
    if ([model.sex isEqualToString:@"男"]) {
        self.sexImageView.image = [UIImage imageNamed:@"iv_man"];
    }else if ([model.sex isEqualToString:@"女"]){
        self.sexImageView.image = [UIImage imageNamed:@"iv_women"];
    }else{
        self.sexImageView.hidden=YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKSocialFKDetailShowTableViewCell";
    MJKSocialFKDetailShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
