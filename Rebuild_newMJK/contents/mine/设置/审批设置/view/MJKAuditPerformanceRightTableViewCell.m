//
//  MJKAuditPerformanceRightTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAuditPerformanceRightTableViewCell.h"

@interface MJKAuditPerformanceRightTableViewCell ()
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *labelArr;
@end

@implementation MJKAuditPerformanceRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    for (int i = 0; i < 18; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 3), 0, (KScreenWidth / 3), 44)];
        label.tag = i + 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:label];
        [self.labelArr addObject:label];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) - 1, 0, 1, 44)];
        view.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:view];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame) - 1, label.frame.size.width, 1)];
        bottomView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:bottomView];
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    for (UILabel *label in self.labelArr) {
        label.text = dataArr[label.tag];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAuditPerformanceRightTableViewCell";
    MJKAuditPerformanceRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (NSMutableArray *)labelArr {
    if (!_labelArr) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}

@end
