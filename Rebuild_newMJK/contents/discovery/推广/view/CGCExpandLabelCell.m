//
//  CGCExpandLabelCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "CGCExpandLabelCell.h"
#import "CGCExpandLabeSublModel.h"

@implementation CGCExpandLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLabelArray:(NSArray *)labelArray {
    _labelArray = labelArray;
    CGFloat margin = 20;
    CGFloat y = 10;
    for (int i = 0; i<labelArray.count; i++) {
        CGCExpandLabeSublModel *subModel = labelArray[i];
        CGSize size = [subModel.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
        
        if ((margin + size.width + 20)  > KScreenWidth) {
            margin = 20;
            y += 30;
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(margin, y, size.width + 10, 20)];
        [button setTitleNormal:subModel.name];
        [button setTitleColor:[UIColor grayColor]];
        if (self.isButtonSelected == YES) {
            [button addTarget:self action:@selector(selectLabel:)];
        }
        button.tag = i + 100;
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        button.layer.cornerRadius = 5.f;
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.contentView addSubview:button];
        margin += size.width + 20;
        
    }
}

- (void)selectLabel:(UIButton *)sender {
    CGCExpandLabeSublModel *subModel = self.labelArray[sender.tag - 100];
    subModel.selected = !subModel.isSelected;
    [sender setBackgroundColor:subModel.isSelected == YES ? [UIColor colorWithHex:@"#DD3D96"] : [UIColor clearColor]];
    [sender setTitleColor:subModel.isSelected == YES ? [UIColor whiteColor] : [UIColor grayColor]];
    sender.layer.borderWidth = subModel.isSelected == YES ? 0 : 1;
    
    if (self.selectLabelBlock) {
        self.selectLabelBlock(subModel);
    }
}

+ (CGFloat)cellHeight:(NSArray *)labelArray {
    CGFloat margin = 20;
    CGFloat y = 10;
    for (int i = 0; i<labelArray.count; i++) {
        CGCExpandLabeSublModel *subModel = labelArray[i];
        CGSize size = [subModel.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size;
        if ((margin + size.width + 20 + 20)  > KScreenWidth) {
            margin = 20;
            y += 30;
        } else {
            margin += size.width + 20;
        }
    }
    return y + 30;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"CGCExpandLabelCell";
    CGCExpandLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
