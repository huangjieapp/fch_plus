//
//  MJKAfterServerProblemTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/1/7.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKAfterServerProblemTableViewCell.h"

@interface MJKAfterServerProblemTableViewCell ()

@end

@implementation MJKAfterServerProblemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTypeArr:(NSArray *)typeArr {
    _typeArr = typeArr;
    CGFloat x = 10;
    CGFloat y = 40;
    for (int i = 0; i < typeArr.count; i++) {
        CGFloat width = [typeArr[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.width;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width + 10, 30)];
        button.layer.cornerRadius = 5.f;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        [button setTitleNormal:typeArr[i]];
        button.tag = 1000 + i;
        [button setTitleColor:[UIColor darkGrayColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonAction:)];
        
        x += width + 15;
        if (x + width + 10 + 15 > KScreenWidth) {
            x = 10;
            y += 40;
        }
        
        if ([self.glNameArray containsObject:typeArr[i]]) {
            if ([button.titleLabel.text isEqualToString:typeArr[i]]) {
                button.layer.borderColor = KNaviColor.CGColor;
                [button setTitleColor:KNaviColor];
                button.selected = YES;
            }
        }
        [self.contentView addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        sender.layer.borderColor = KNaviColor.CGColor;
        [sender setTitleColor:KNaviColor];
        if (self.buttonActionBlock) {
            self.buttonActionBlock(@"selected",sender.tag - 1000);
        }
    } else {
        sender.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [sender setTitleColor:[UIColor darkGrayColor]];
        if (self.buttonActionBlock) {
            self.buttonActionBlock(@"unselected",sender.tag - 1000);
        }
    }
    
    
}

- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    NSArray *arr = [typeName componentsSeparatedByString:@","];
    CGFloat x = 10;
    CGFloat y = 40;
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i] length] > 0) {
            CGFloat width = [arr[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.width;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, width + 10, 30)];
            label.textColor = KNaviColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14.f];
            label.text = arr[i];
            label.layer.cornerRadius = 5.f;
            label.layer.borderColor = KNaviColor.CGColor;
            label.layer.borderWidth = 1;
            x += width + 15;
            if (x + width + 10 + 15 > KScreenWidth) {
                x = 10;
                y += 40;
            }
            [self.contentView addSubview:label];
        }
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKAfterServerProblemTableViewCell";
    MJKAfterServerProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
@end
