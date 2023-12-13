//
//  MJKShoppingCartCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKShoppingCartCell.h"
#import "MJKProductShowModel.h"

@interface MJKShoppingCartCell ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UITextView *desTV;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLayout;

@end

@implementation MJKShoppingCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.desTV.delegate = self;
    self.desTV.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 0);
}

- (void)setModel:(MJKProductShowModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.X_FMPICURL]];
    self.productLabel.text =model.X_REMARK;
//    self.desTV.text = model.C_NAME;
    self.priceTF.text = [NSString stringWithFormat:@"%ld",(long)model.B_HDJ.integerValue];
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)model.number];
    if (model.number == 0) {
        self.subButton.hidden = self.countLabel.hidden = YES;
    } else {
        self.subButton.hidden = self.countLabel.hidden = NO;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:10],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.desTV.attributedText = [[NSAttributedString alloc] initWithString:model.C_NAME attributes:attributes];
    
    CGSize size = [model.C_NAME boundingRectWithSize:CGSizeMake(KScreenWidth - 238, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} context:nil].size;
    self.textViewLayout.constant = size.height + 10;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.model.C_NAME = textView.text;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:10],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    CGSize size = [textView.text boundingRectWithSize:CGSizeMake(KScreenWidth - 238, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.f]} context:nil].size;
    self.textViewLayout.constant = size.height + 10;
    
    if (self.updateBlock) {
        self.updateBlock();
    }
}

- (IBAction)priceTFChange:(UITextField *)sender {
    self.model.B_HDJ = sender.text;
    if (self.priceChangeBlock) {
        self.priceChangeBlock();
    }
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
    static NSString *ID = @"MJKShoppingCartCell";
    MJKShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
