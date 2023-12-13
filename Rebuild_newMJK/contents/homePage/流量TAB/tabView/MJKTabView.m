//
//  MJKTabView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/20.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTabView.h"

typedef void(^Block)(NSString *str);

@interface MJKTabView ()
/** button*/
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) Block buttonClickBlock;
@end

@implementation MJKTabView

- (instancetype)initWithFrame:(CGRect)frame andNameItems:(NSArray *)items withDefaultIndex:(NSInteger)index andIsSaveItem:(BOOL)isSave andClickButtonBlock:(void(^)(NSString *str))buttonClickBlock {
	if (self = [super initWithFrame:frame]) {
		[self configUI:frame andNameItems:items withDefaultIndex:index andIsSaveItem:isSave andClickButtonBlock:buttonClickBlock];
	}
	return self;
}

- (void)configUI:(CGRect )frame andNameItems:(NSArray *)items withDefaultIndex:(NSInteger)index andIsSaveItem:(BOOL)isSave andClickButtonBlock:(void(^)(NSString *str))buttonClickBlock {
	self.buttonClickBlock = buttonClickBlock;
	UIView *bgView = [[UIView alloc]init];
	
	[self addSubview:bgView];
//	CGRectMake(0, 10, frame.size.width, frame.size.height)
	[bgView addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(5.f, 5.f) viewRect:frame];
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	gradientLayer.frame = frame;  // 设置显示的frame
	gradientLayer.colors = @[(id)[UIColor colorWithHexString:@"#3B000000"].CGColor,(id)[UIColor colorWithHexString:@"#3B999999"].CGColor,(id)[UIColor colorWithHexString:@"#3B000000"].CGColor];  // 设置渐变颜色
	//    gradientLayer.locations = @[@0.0, @0.2, @0.5];    // 颜色的起点位置，递增，并且数量跟颜色数量相等
	gradientLayer.startPoint = CGPointMake(0, 0);   //
	gradientLayer.endPoint = CGPointMake(0, 1);     //
	[bgView.layer addSublayer:gradientLayer];
	bgView.backgroundColor = [UIColor redColor];
	for (int i = 0; i < items.count; i++) {
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (frame.size.width / items.count), frame.origin.y, frame.size.width / items.count, frame.size.height)];
        [button setTitle:items[i] forState:UIControlStateNormal];
//		[button setTitle:items[i]];
		[button setTitleColor:[UIColor whiteColor]];
		button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        NSString *str;
        if (isSave == YES) {
            if ([[KUSERDEFAULT objectForKey:@"tabSelect"] isEqualToString:@"客户"]) {
                str = [KUSERDEFAULT objectForKey:@"customerTabName"];
            } else if  ([[KUSERDEFAULT objectForKey:@"tabSelect"] isEqualToString:@"流量"]){
                str = [KUSERDEFAULT objectForKey:@"clueTabName"];
            }
        }
        
        if (str.length > 0) {
            index = [items indexOfObject:str];
        }
       
		if (i == index) {
			self.button = button;
			[button setTitleColor:[UIColor blackColor]];
			[button setBackgroundColor:[UIColor whiteColor]];
		}
		
		[button addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(5.f, 5.f)];
		[button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//		[bgView addSubview:button];
		[self addSubview:button];
	}
	
//	UIButton *button = [[UIButton alloc]initWithFrame:frame];
//	[button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
////	[bgView addSubview:button];
//	[self addSubview:button];
	
	
//	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (frame.size.width / items.count), 0, frame.size.width / items.count, frame.size.height)];
}


- (void)clickAction:(UIButton *)sender {
	[self.button setBackgroundColor:[UIColor clearColor]];
	[self.button setTitleColor:[UIColor whiteColor]];
	
	[sender setBackgroundColor:[UIColor whiteColor]];
	[sender setTitleColor:[UIColor blackColor]];
//	[sender addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight withRadii:CGSizeMake(5.f, 5.f)];
	self.button = sender;
	if (self.buttonClickBlock) {
        self.buttonClickBlock(sender.titleLabel.text);
	}
}
@end
