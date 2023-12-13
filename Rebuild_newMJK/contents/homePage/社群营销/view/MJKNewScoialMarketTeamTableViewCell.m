//
//  MJKScoialMarketTeamDetailTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNewScoialMarketTeamTableViewCell.h"
#import "MJKSocialMarketTeamListModel.h"

@interface MJKNewScoialMarketTeamTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNumber;
@property (weak, nonatomic) IBOutlet UILabel *shareNumber;
@property (weak, nonatomic) IBOutlet UILabel *readNumber;
@property (weak, nonatomic) IBOutlet UILabel *readCount;
@property (weak, nonatomic) IBOutlet UILabel *clueCount;

@end

@implementation MJKNewScoialMarketTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKSocialMarketTeamListModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.faceurl]];
    self.nameLabel.text = model.name;
    self.teamNumber.text = model.teamNumber;
    self.shareNumber.text = model.materialNumber;
    self.readNumber.text = [NSString stringWithFormat:@"%@/%@",model.shareNumber,model.forwardNumber];
    self.readCount.text = [NSString stringWithFormat:@"%@/%@",model.readNumber,model.readCount];
    self.clueCount.text = model.customerCount;
}

- (void)setSubModel:(MJKSocialMarketTeamListModel *)subModel {
    _subModel = subModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:subModel.faceurl]];
    self.nameLabel.text = subModel.name;
    self.teamNumber.text = subModel.shareNumber;
    self.shareNumber.text = subModel.readNumber;
    self.readNumber.text = subModel.readCount;
    self.readCount.text = subModel.customerCount;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKNewScoialMarketTeamTableViewCell";
    MJKNewScoialMarketTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
