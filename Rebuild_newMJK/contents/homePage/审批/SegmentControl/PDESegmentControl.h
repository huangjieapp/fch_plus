//
//  PDESegmentControl.h
//  TestSegment
//
//  Created by brain on 14/12/5.
//  Copyright (c) 2014年 marry. All rights reserved.
//


typedef void(^btnTag)(int);
#import <UIKit/UIKit.h>

@interface PDESegmentControl : UIView
{
    NSMutableArray *segmentButtons;
    NSMutableArray *buttonImgNames;
//    UIButton *_button;
    
}
@property(nonatomic,strong)UIButton* button;
@property (readonly, nonatomic)  NSInteger selectedSegmentIndex;
@property(nonatomic,strong)btnTag changeSegBtnIndex;
//@property(nonatomic,strong)UIFont* font;
- (id) initWithFrame:(CGRect)frame items:(NSArray*)itemArray;
- (id) initWithFrame:(CGRect)frame item:(NSArray*)itemArray;
-(void)setSegmentIndex:(NSInteger)index;
-(void)buttonFont:(UIFont*)font;
@end


