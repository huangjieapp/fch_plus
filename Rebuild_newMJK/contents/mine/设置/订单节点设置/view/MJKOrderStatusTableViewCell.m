//
//  MJKOrderStatusTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKOrderStatusTableViewCell.h"

@interface MJKOrderStatusTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MJKOrderStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.selectImageView.image = [UIImage imageNamed:[dataDic[@"isSelect"] isEqualToString:@"1"] ? @"选中" : @"未选中"];
    self.nameLabel.text = dataDic[@"name"];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKOrderStatusTableViewCell";
    MJKOrderStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
