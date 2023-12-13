//
//  MJKScoialMarketTeamTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKScoialMarketTeamTableViewCell.h"
#import "MJKSocialMarketHeaderModel.h"

@interface MJKScoialMarketTeamTableViewCell ()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *nameLabelArray;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end

@implementation MJKScoialMarketTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(MJKSocialMarketHeaderModel *)model {
    _model = model;
    NSString *detailStr = [NSString stringWithFormat:@"%@次分享%@次转发,共%@人浏览%@次",model.allShareNumber,model.allForwardNumber,model.allReadNumber,model.allReadCount];
    self.detailLabel.text = detailStr;
}

- (void)setNameArray:(NSArray *)nameArray {
    _nameArray = nameArray;
    for (int i = 0; i < self.nameLabelArray.count; i++) {
        UILabel *label = self.nameLabelArray[i];
        label.text = nameArray[i];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKScoialMarketTeamTableViewCell";
    MJKScoialMarketTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
