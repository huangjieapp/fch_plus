//
//  MJKCustomerAddressTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/6.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCustomerAddressTableViewCell.h"

@interface MJKCustomerAddressTableViewCell ()<UITextViewDelegate>
@end

@implementation MJKCustomerAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputAddressTextView.delegate = self;
     // _placeholderLabel
     UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.textAlignment = NSTextAlignmentRight;
     placeHolderLabel.text = @"请输入详细地址";
     placeHolderLabel.numberOfLines = 0;
     placeHolderLabel.textColor = [UIColor lightGrayColor];
     [placeHolderLabel sizeToFit];
     [self.inputAddressTextView addSubview:placeHolderLabel];
     
     // same font
     self.inputAddressTextView.font = [UIFont systemFontOfSize:14.f];
     placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
     
     [self.inputAddressTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

- (IBAction)chooseArea:(UIButton *)sender {
    if (self.selectAreaBlock) {
        self.selectAreaBlock();
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.changeTextBlock) {
        self.changeTextBlock(textView.text);
    }
}

- (CGFloat)cellHeight {
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
    CGSize size = [self.inputAddressTextView.text boundingRectWithSize:CGSizeMake(self.inputAddressTextView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if (size.height > 150) {
        return size.height + 10;
    } else {
        return 150;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKCustomerAddressTableViewCell";
    MJKCustomerAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
