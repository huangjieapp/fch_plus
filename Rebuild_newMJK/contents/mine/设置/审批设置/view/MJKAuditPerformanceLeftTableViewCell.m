//
//  MJKAuditPerformanceLeftTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAuditPerformanceLeftTableViewCell.h"

@interface MJKAuditPerformanceLeftTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation MJKAuditPerformanceLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.nameLabel.text = dataArr[0];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAuditPerformanceLeftTableViewCell";
    MJKAuditPerformanceLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
