//
//  MJKScoialMarketTeamDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKScoialMarketTeamDetailTableViewCell.h"
#import "MJKSocialMarketTeamListModel.h"

@interface MJKScoialMarketTeamDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNumber;
@property (weak, nonatomic) IBOutlet UILabel *shareNumber;
@property (weak, nonatomic) IBOutlet UILabel *readNumber;
@property (weak, nonatomic) IBOutlet UILabel *readCount;

@end

@implementation MJKScoialMarketTeamDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKSocialMarketTeamListModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.faceurl]];
    self.nameLabel.text = model.name;
    self.teamNumber.text = model.teamNumber;
    self.shareNumber.text = model.shareNumber;
    self.readNumber.text = model.readNumber;
    self.readCount.text = model.readCount;
}

- (void)setSubModel:(MJKSocialMarketTeamListModel *)subModel {
    _subModel = subModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:subModel.faceurl]];
    self.nameLabel.text = subModel.name;
    self.teamNumber.text = subModel.materialNumber;
    self.shareNumber.text = [NSString stringWithFormat:@"%@/%@",subModel.shareNumber,subModel.forwardNumber];
    self.readNumber.text = [NSString stringWithFormat:@"%@/%@",subModel.readNumber,subModel.readCount];
    self.readCount.text = subModel.customerCount;
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKScoialMarketTeamDetailTableViewCell";
    MJKScoialMarketTeamDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
