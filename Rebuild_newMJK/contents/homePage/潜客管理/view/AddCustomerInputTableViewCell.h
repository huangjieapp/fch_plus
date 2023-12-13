//
//  AddCustomerInputTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface AddCustomerInputTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *titleBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftLayout;
@property (weak, nonatomic) IBOutlet UIImageView *followImage;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLabel;
/** <#注释#> */
@property (nonatomic, strong) NSString *allNumber;
@property (weak, nonatomic) IBOutlet  CustomTextField*inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputRightValue;  //10  查重110 查重宽90
@property(nonatomic,copy)void(^changeTextBlock)(NSString*textStr);
@property(nonatomic,copy)void(^textBeginEditBlock)(void);
@property(nonatomic,copy)void(^textEndEditBlock)(void);
@property(nonatomic,copy)void(^tfEndEditBlock)(NSString*text);
@property(nonatomic,copy)void(^tfBeginEditBlock)(NSString*text);
@property(nonatomic,copy)void(^clickButtonBlock)(void);

@property(nonatomic,strong)NSString*textStr;   //默认值


//只有电话号码有 限制字数  11位之后不能再输了
@property(nonatomic,assign)NSInteger textFieldLength;

//默认是240
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputWith;
//默认是10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputRight;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIButton *findCopyButton;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
/** textViewPlaceholder*/
@property (nonatomic, strong) UILabel *textViewPlaceHolderLabel;

@end
