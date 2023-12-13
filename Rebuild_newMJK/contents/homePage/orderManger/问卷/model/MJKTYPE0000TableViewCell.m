//
//  MJKTYPE0000TableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/8.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKTYPE0000TableViewCell.h"

#import "RatingBar.h"

#import "MJKA808PojoListModel.h"
#import "MJKA809PojoListModel.h"
#import "MJKA810PojoListModel.h"

@interface MJKTYPE0000TableViewCell ()<UITextViewDelegate, RatingDelegate>
@end

@implementation MJKTYPE0000TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setA808Model:(MJKA808PojoListModel *)a808Model {
    _a808Model = a808Model;
    self.titleLabel.text = a808Model.C_NAME;
    CGFloat height = [a808Model.C_NAME boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0000"] || [a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0003"]) {//单选//多选
        for (int i = 0; i < a808Model.a809PojoList.count; i++) {
            MJKA809PojoListModel *a809Model = a808Model.a809PojoList[i];
            CGFloat width = [a809Model.C_NAME boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.width;
            
            if ((x + (width + 40)) > KScreenWidth) {
                x = 0;
                y += 40;
            }
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x, height + 16 + y, width + 40, 30)];
            [button setTitle:a809Model.C_NAME forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:a809Model.isSelected == YES ? @"选中" : @"未选中"] forState:UIControlStateNormal];
           
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            button.tag = 10 + i;
            [button addTarget:self action:@selector(radioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            x += (width + 40);
            
        }
    } else if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0001"]) {//文本
        CGFloat tvH = 60;
        
        UITextView *tv = [[UITextView alloc]initWithFrame:CGRectMake(10, height + 16, KScreenWidth - 20, tvH)];
        
        tv.layer.borderColor = kBackgroundColor.CGColor;
        tv.layer.borderWidth = 1;
        [self.contentView addSubview:tv];
        for (MJKA808PojoListModel *a808SubModel in self.a808Arr) {
            if ([a808Model.C_ID isEqualToString:a808SubModel.C_ID]) {
                if (a808SubModel.X_REMARK.length > 0) {
                    tv.text = a808SubModel.X_REMARK;
                }
            }
        }
        // _placeholderLabel
           UILabel *placeHolderLabel = [[UILabel alloc] init];
           placeHolderLabel.text = @"请输入内容";
           placeHolderLabel.numberOfLines = 0;
           placeHolderLabel.textColor = [UIColor lightGrayColor];
           [placeHolderLabel sizeToFit];
           [tv addSubview:placeHolderLabel];
        tv.delegate = self;

           // same font
        tv.font = [UIFont systemFontOfSize:13.f];
           placeHolderLabel.font = [UIFont systemFontOfSize:13.f];

           [tv setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
    } else if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0002"]) {//评分
        RatingBar *bar = [[RatingBar alloc]initWithFrame:CGRectMake(0, height + 25, KScreenWidth, 25)];
        bar.delegate = self;
        [self.contentView addSubview:bar];
        for (MJKA808PojoListModel *a808SubModel in self.a808Arr) {
            if ([a808Model.C_ID isEqualToString:a808SubModel.C_ID]) {
                if (a808SubModel.I_TYPE.length > 0) {
                    bar.starNumber = a808SubModel.I_TYPE.integerValue;
                }
            }
        }
        
    }
}

- (void)setRating:(NSInteger)rating isHuman:(BOOL)isHuman andTag:(NSInteger)tag {
    if ([self.a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0002"]) {//评分
        if (self.radioButtonBlock) {
            self.radioButtonBlock([[MJKA809PojoListModel alloc]init], @[], @"", [NSString stringWithFormat:@"%ld",(long)rating]);
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0001"]) {//文本
        if (self.radioButtonBlock) {
            self.radioButtonBlock([[MJKA809PojoListModel alloc]init], @[], textView.text, @"");
        }
    }
}

- (void)setA810Model:(MJKA810PojoListModel *)a810Model {
    _a810Model = a810Model;
    self.titleLabel.text = a810Model.C_A80800_C_NAME;
    CGFloat height = [a810Model.C_A80800_C_NAME boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    CGFloat tvH = [a810Model.C_ANSWER boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height + 20;
    UITextView *tv = [[UITextView alloc]initWithFrame:CGRectMake(10, height + 16, KScreenWidth - 20, tvH)];
    if (a810Model.C_ANSWER.length > 0) {
        tv.text = a810Model.C_ANSWER;
    }
    tv.layer.borderColor = kBackgroundColor.CGColor;
    tv.layer.borderWidth = 1;
    tv.editable = NO;
    [self.contentView addSubview:tv];
}

- (void)radioButtonAction:(UIButton *)sender {
    MJKA809PojoListModel *chooseA809Model = self.a808Model.a809PojoList[sender.tag - 10];
    if ([self.a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0000"]) {//单选
        for (MJKA809PojoListModel *a809Model in self.a808Model.a809PojoList) {
            a809Model.selected = NO;
        }
        chooseA809Model.selected = YES;
        
        [sender setImage:[UIImage imageNamed:chooseA809Model.isSelected == YES ? @"选中" : @"未选中"] forState:UIControlStateNormal];
        
        if (self.radioButtonBlock) {
            self.radioButtonBlock(chooseA809Model, @[], @"", @"");
        }
    } else if ([self.a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0001"]) {//文本
        if (self.radioButtonBlock) {
            self.radioButtonBlock(chooseA809Model, @[], @"", @"");
        }
    } else if ([self.a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0002"]) {//评分
        if (self.radioButtonBlock) {
            self.radioButtonBlock(chooseA809Model, @[], @"", @"11");
        }
    } else if ([self.a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0003"]) {//多选
        chooseA809Model.selected = !chooseA809Model.isSelected;
        [sender setImage:[UIImage imageNamed:chooseA809Model.isSelected == YES ? @"选中" : @"未选中"] forState:UIControlStateNormal];
        NSMutableArray *arr = [NSMutableArray array];
        for (MJKA809PojoListModel *subModel in self.a808Model.a809PojoList) {
            if (subModel.isSelected == YES) {
                [arr addObject:subModel.C_ID];
            }
        }
        if (self.radioButtonBlock) {
            self.radioButtonBlock(chooseA809Model, arr, @"", @"");
        }
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKTYPE0000TableViewCell";
    MJKTYPE0000TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return cell;
    
}

+ (CGFloat)heightForModel:(MJKA808PojoListModel *)a808Model {
    CGFloat height = [a808Model.C_NAME boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0000"]) {//单选
        CGFloat x = 0;
        CGFloat y = 0;
        for (int i = 0; i < a808Model.a809PojoList.count; i++) {
            MJKA809PojoListModel *a809Model = a808Model.a809PojoList[i];
            CGFloat width = [a809Model.C_NAME boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.width;
            
            if ((x + (width + 40)) > KScreenWidth) {
                x = 0;
                y += 40;
            }
            x += (width + 40);
            
        }
        
        return height + 16 + y + 40;
    } else if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0001"]) {//文本
            
        return height + 16 + 80;
    } else if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0002"]) {//评分
        return height + 25 + 35;
        
    }
    return height + 16 + 80;
}

+ (CGFloat)heightForA810Model:(MJKA810PojoListModel *)a810Model {
    CGFloat height = [a810Model.C_A80800_C_NAME boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
    CGFloat tvH = [a810Model.C_ANSWER boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height + 30;
    return height + 16 + tvH;
}


@end
