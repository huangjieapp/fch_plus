//
//  DropdownButton.m
//  Common
//
//  Created by Ryan Wong on 15/9/9.
//  Copyright (c) 2015年 tenfoldtech. All rights reserved.
//

#import "DropdownButton.h"
#import "CommonDefine.h"

#define BUTTON_HEIGHT 40.0

@implementation DropdownButton

- (id)initDropdownButtonWithTitles:(NSArray*)titles{
    self = [super initWithFrame:CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT, SCREEN_WIDTH, BUTTON_HEIGHT)];
    if (self) {
//        self.backgroundColor=[UIColor greenColor];
        _isButtion = NO;
        _count = titles.count;
        [self addButtonToView:titles];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu:) name:@"hideMenu" object:_lastTapObj];
        
        [self addImageButton];
        
    }
    return self;
}

-(void)addImageButton{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth-40, 10, 1, 20)];
    lineView.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
    [self addSubview:lineView];

    
    
    UIButton*imageButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-40+10, 10, 20, 20)];
    [imageButton setBackgroundImage:[UIImage imageNamed:@"漏斗"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(clickImageButton:)];
    [self addSubview:imageButton];
    
    
}





- (void)addButtonToView:(NSArray *)titles {
    saveAllButton=[NSMutableArray array];
    for (int i = 0; i < _count; i++) {
        UIButton *button = [self makeButton:[titles objectAtIndex:i] andIndex:i];
        [self addSubview:button];
        [saveAllButton addObject:button];
        if (i > 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x, 10, 1, 20)];
            lineView.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
            [self addSubview:lineView];
        }
    }
    
    for (int i=0; i<=_count; i++) {
        
    }
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTON_HEIGHT, SCREEN_WIDTH, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1.0f];
    [self addSubview:bottomLine];
}

- (UIButton *)makeButton:(NSString *) title andIndex:(int)index{
    float width = [self returnTitlesWidth];
    float offsetX = width * index;
    _image = [UIImage imageNamed:@"expandableImage"];
    float padding = (width - (_image.size.width + [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width)) / 2;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, width, BUTTON_HEIGHT)];
    button.tag = 10000 + index;
    [button setImage:_image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(11, [title sizeWithFont:[UIFont systemFontOfSize:13.0f]].width + padding + 5, 11, 0)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(11, 0, 11, _image.size.width + 5)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (float)returnTitlesWidth {
    float width = (SCREEN_WIDTH-40)/ _count;
    return width;
}

#pragma mark  -- touch
-(void)clickImageButton:(UIButton*)sender{
    MyLog(@"..");
         [self.delegate hideMenu];
    for (UIButton*button in saveAllButton) {
        button.selected=NO;
    }

    
    if (sender.selected) {
        sender.selected=NO;
        //隐藏 展示的框
      
        [self.delegate hideRightView];
        
    }else{
        sender.selected=YES;
        //显示展示的框
         [self.delegate showRightView];
        
    }
    
    
}



- (void)showMenuAction:(UIButton*)sender {
      [self.delegate hideRightView];
    
    NSInteger i = sender.tag;
    [self openMenuBtnAnimation:i];
}

- (void)openMenuBtnAnimation:(NSInteger)index{
    if (_lastTap != index) {
        if (_lastTap > 0) {
            [self changeButtionTag:_lastTap Rotation:0];
        }
        _lastTap = index;
        [self changeButtionTag:index Rotation:M_PI];
        [self.delegate showMenu:index];
    } else {
        _isButtion = YES;
        [self changeButtionTag:_lastTap Rotation:0];
        _lastTap = 0;
        [self.delegate hideMenu];
    }
}

- (void)hideMenu:(NSNotification *)notification {
    _lastTapObj = [notification object];
    if (_isButtion != YES) {
        [self changeButtionTag:([_lastTapObj intValue] + 10000) Rotation:0];
        _isButtion = NO;
    }
    _lastTap = 0;
}

- (void)changeButtionTag:(NSInteger)index Rotation:(CGFloat)angle {
    [UIView animateWithDuration:0.1f animations:^{
        UIButton *btn = (UIButton *)[self viewWithTag:index];
        if (angle == 0) {
            [btn setBackgroundColor:[UIColor whiteColor]];
        } else {
            [btn setBackgroundColor:[UIColor colorWithRed:(221.0/255.0) green:(221.0/255.0) blue:(221.0/255.0) alpha:1.0f]];
        }
        btn.imageView.transform = CGAffineTransformMakeRotation(angle);
    }];
}

@end
