//
//  CGCNavSearchTextView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/29.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCNavSearchTextView.h"

@interface CGCNavSearchTextView ()<UITextFieldDelegate>

@property (nonatomic,copy) RECORDCLICK recordC;

@property (nonatomic,copy) TEXTCLICK textC;

@property (nonatomic,copy) ENDTEXTCLICK endC;

@property (nonatomic, strong) UIButton  *bgBtn;


@end

@implementation CGCNavSearchTextView



//+ (instancetype)initWithTarget:(id)target  {
//
//    CGCNavSearchTextView *textView;
//    if (textView==nil) {
//        
//      
//        textView=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
//
//    }
//
//    return textView;
//
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCNavSearchTextView class]) owner:self options:nil] lastObject];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withPlaceHolder:(NSString *)placeHolder withRecord:(RECORDCLICK)record withText:(TEXTCLICK)text withEndText:(ENDTEXTCLICK)end{

    self = [super initWithFrame:frame];
    if (self) {
        self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCNavSearchTextView class]) owner:self options:nil] lastObject];
        self.recordC=record;
        self.textC=text;
        self.endC = end;
        self.textField.placeholder=placeHolder;
        self.textField.delegate=self;
        self.textField.returnKeyType=UIReturnKeySearch;
        [self.recordBtn addTarget:self action:@selector(clickRecord)];
        [self.textField addTarget:self action:@selector(textBeign) forControlEvents:UIControlEventEditingDidBegin];
        [self.textField addTarget:self action:@selector(endEidt:) forControlEvents:UIControlEventEditingDidEnd];
		 [self.textField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];

        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    if (self.widthSet.length > 0) {
        frame.size.width = KScreenWidth - 200;
    }
    [super setFrame:frame];
}


//录音点击
- (void)clickRecord{
    if (self.recordC) {
        self.recordC();
    }
}
//开始编辑
- (void)textBeign{
    
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(disView)];
    btn.frame=window.bounds;
    btn.backgroundColor=[UIColor clearColor];
    [window addSubview:btn];
    self.bgBtn=btn;
    
    [UIView animateWithDuration:2 animations:^{
        self.iconLead.constant=5;
    }];
    if (self.textC) {
        self.textC();
    }
}
//结束编辑
- (void)endEidt:(UITextField *)textF{

    [UIView animateWithDuration:2 animations:^{
        self.iconLead.constant=15;
    }];
    NSString * str=nil;
    str = textF.text.length==0?@"":textF.text;
    if (self.endC) {
        self.endC(str);
    }
    
}
//正在编辑
- (void)changeText:(UITextField *)textF {
	if (self.changeBlock) {
		self.changeBlock(textF.text);
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self disView];
    return YES;
}

- (void)disView{
    [self.bgBtn removeFromSuperview];
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)drawRect:(CGRect)rect {
   
    self.layer.cornerRadius=15.0;
    self.layer.masksToBounds=YES;

  }
- (void)layoutSubviews{

    self.width=220;
    self.height=30;

}



-(CGSize)intrinsicContentSize{

  return   CGSizeMake(220, 30);
}
@end
