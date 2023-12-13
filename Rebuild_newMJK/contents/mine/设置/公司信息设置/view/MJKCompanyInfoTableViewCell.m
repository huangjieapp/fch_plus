//
//  MJKCompanyInfoTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCompanyInfoTableViewCell.h"

@interface MJKCompanyInfoTableViewCell ()<UITextViewDelegate>
@end

@implementation MJKCompanyInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请填写公司介绍...";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [_infoTextView addSubview:placeHolderLabel];
    
    // same font
    _infoTextView.font = [UIFont systemFontOfSize:14.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    
    [_infoTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    _infoTextView.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView {
    if (self.textChangeBlock) {
        self.textChangeBlock(textView.text);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKCompanyInfoTableViewCell";
    MJKCompanyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
