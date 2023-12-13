//
//  CGCNavSearchTextView.h
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

/*
 
 使用说明
 self.titleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入手机/客户姓名" withRecord:^{//点击录音
 
 } withText:^{//开始编辑
 
 }withEndText:^(NSString *str) {//结束编辑
 NSLog(@"%@____",str);
 }];
 self.navigationItem.titleView=self.titleView;
 */




#import <UIKit/UIKit.h>

typedef void(^TEXTCLICK)();
typedef void(^RECORDCLICK)();
typedef void(^ENDTEXTCLICK)(NSString * str);
typedef void(^CHANGEBLOCK)(NSString * str);
@interface CGCNavSearchTextView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLead;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic, assign) CGSize intrinsicContentSize;

@property (nonatomic, copy) CHANGEBLOCK changeBlock;

//+ (instancetype)initWithTarget:(id)target;

- (instancetype)initWithFrame:(CGRect)frame withPlaceHolder:(NSString *)placeHolder withRecord:(RECORDCLICK)record withText:(TEXTCLICK)text withEndText:(ENDTEXTCLICK)end;

@end
