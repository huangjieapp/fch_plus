//
//  CGCNewAppointTextCell.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/30.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ENDBLOCK)();

@interface CGCNewAppointTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mustLabel;
/** <#注释#> */
@property (nonatomic, strong) NSString *placeholderStr;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftLayout;

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;

//@property (weak, nonatomic) IBOutlet UITextField *remarkText;
//
//@property (weak, nonatomic) IBOutlet UILabel *remarkLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomLayout;
@property (weak, nonatomic) IBOutlet UITextView *textView;
/** 语音图*/
@property (nonatomic, strong) UIButton *voiceButton;
@property(nonatomic,strong)NSString*beforeText;
@property(nonatomic,copy)void(^changeTextBlock)(NSString*textStr);

@property(nonatomic,copy)void(^startInputBlock)();
@property (nonatomic, copy) ENDBLOCK endBlock;

@end
