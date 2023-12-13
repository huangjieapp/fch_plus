//
//  MJKProductShowTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKProductShowTableViewCell.h"
#import "MJKProductShowModel.h"

@interface MJKProductShowTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDes;
@property (weak, nonatomic) IBOutlet UILabel *productPay;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet UILabel *productNum;
@property (weak, nonatomic) IBOutlet UILabel *productOriginalPrice;

@end

@implementation MJKProductShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProductArray:(NSArray *)productArray {
    _productArray = productArray;
    for (MJKProductShowModel *model in productArray) {
        if ([model.C_ID isEqualToString:self.model.C_ID]) {
            if (model.number == 0) {
                self.productNum.hidden = YES;
                self.subButton.hidden = YES;
            } else {
                self.productNum.hidden = NO;
                self.subButton.hidden = NO;
            }
            
            self.productNum.text = [NSString stringWithFormat:@"%ld",model.number];
        }
    }
}

- (void)setModel:(MJKProductShowModel *)model {
    _model = model;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.X_FMPICURL]];
    self.productName.text = model.X_REMARK;
    self.productDes.text = model.C_NAME;
    self.productPay.text = [NSString stringWithFormat:@"¥ %ld",(long)model.B_HDJ.integerValue];
//    if (model.B_YJ.length > 0) {
//        NSString *yjStr = [NSString stringWithFormat:@"¥ %@",model.B_YJ];
//        //中划线
//        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:yjStr attributes:attribtDic];
//        self.productOriginalPrice.attributedText = attribtStr;
//        self.productOriginalPrice.hidden = NO;
//    } else {
//        self.productOriginalPrice.hidden = YES;
//    }
}
- (IBAction)addProductButton:(UIButton *)sender {
    if (self.addOrSubProductActionBlock) {
        self.addOrSubProductActionBlock(@"+");
    }
}
- (IBAction)subProductAction:(UIButton *)sender {
    if (self.addOrSubProductActionBlock) {
        self.addOrSubProductActionBlock(@"-");
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKProductShowTableViewCell";
    MJKProductShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
