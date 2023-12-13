//
//  MJKAdditionalTrackTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/2.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAdditionalTrackTableViewCell.h"
#import "MJKAdditionalTrackModel.h"

@interface MJKAdditionalTrackTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation MJKAdditionalTrackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKAdditionalTrackModel *)model {
    _model = model;
    self.typeLabel.text = [NSString stringWithFormat:@"类型:%@",model.C_TYPE_DD_NAME];
    self.lastTimeLabel.text = [NSString stringWithFormat:@"最后更新时间:%@",model.D_LASTUPDATE_TIME];
    self.remarkLabel.text = model.X_REMARK;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAdditionalTrackTableViewCell";
    MJKAdditionalTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
