//
//  PDESegmentControl.m
//  TestSegment
//
//  Created by brain on 14/12/5.
//  Copyright (c) 2014年 marry. All rights reserved.
//

#import "PDESegmentControl.h"
#define SEGMENT_UNSELECTED 0
#define SEGMENT_SELECTED 1
@implementation PDESegmentControl
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame items:(NSArray*)itemArray
{
    self = [super initWithFrame:frame];
    if (self) {
        int segmentCount = [itemArray count];
        segmentButtons = [[NSMutableArray alloc] init];
        buttonImgNames = [[NSMutableArray alloc] init];
        float segmentWidth = frame.size.width/segmentCount;
        for (int i=0; i<segmentCount; i++) {
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = CGRectMake(segmentWidth*i, 0,
                                      segmentWidth, frame.size.height);
            [self buttonFont:_button.titleLabel.font];
            
//            if (i==0) { //left
//                [buttonImgNames addObject:@"segmentleftnormal"];
//                [buttonImgNames addObject:@"segmentleft"];
//                [_button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//            }else if(i==segmentCount-1){ //right
//                [buttonImgNames addObject:@"segmentrightnormal"];
//                [buttonImgNames addObject:@"segmentrightselcet"];
//            }else{ //middle
//                [buttonImgNames addObject:@"segmentcenter"];
//                [buttonImgNames addObject:@"segmentcenterselect"];
//                
//                
//            }
            
            if (i==0) { //left
                [buttonImgNames addObject:@"白1-1"];
                [buttonImgNames addObject:@"黄1"];
                [_button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            }else if(i==segmentCount-1){ //right
                [buttonImgNames addObject:@"白2"];
                [buttonImgNames addObject:@"黄2"];
            }else{ //middle
                [buttonImgNames addObject:@"白23"];
                [buttonImgNames addObject:@"segmentcenterselect"];
                
                
            }
            
            _button.tag = i;
            [_button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
            [_button setTitle:[itemArray objectAtIndex:i] forState:UIControlStateNormal];
            [segmentButtons addObject:_button];
            
            [self addSubview:_button];
            
        }
        [self setSegmentIndex:0];
        
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame item:(NSArray*)itemArray
{
    self = [super initWithFrame:frame];
    if (self) {
        int segmentCount = [itemArray count];
        segmentButtons = [[NSMutableArray alloc] init];
        buttonImgNames = [[NSMutableArray alloc] init];
      float segmentWidth = frame.size.width/segmentCount;
        
        for (int i=0; i<segmentCount; i++) {
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.frame = CGRectMake(segmentWidth*i, 0,
                                       segmentWidth, frame.size.height);
            [self buttonFont:_button.titleLabel.font];
            
//            if (i==0) { //left
//                [buttonImgNames addObject:@"segmentleftnormal"];
//                [buttonImgNames addObject:@"segmentleft"];
//                [_button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
//            }else if(i==segmentCount-1){ //right
//                [buttonImgNames addObject:@"segmentrightnormal"];
//                [buttonImgNames addObject:@"segmentrightselcet"];
//            }else{ //middle
//                [buttonImgNames addObject:@"segmentcenter"];
//                [buttonImgNames addObject:@"segmentcenterselect"];
//
//            }
            if (i==0) { //left
                [buttonImgNames addObject:@"白1"];
                [buttonImgNames addObject:@"黄1"];
                [_button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
            }else if(i==segmentCount-1){ //right
                [buttonImgNames addObject:@"白2"];
                [buttonImgNames addObject:@"黄2"];
            }else{ //middle
                [buttonImgNames addObject:@"矩形-12-拷贝"];//矩形-12-拷贝
                [buttonImgNames addObject:@"segmentcenterselect"];
                
                
            }

            _button.tag = i;
            [_button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
            [_button setTitle:[itemArray objectAtIndex:i] forState:UIControlStateNormal];
            [segmentButtons addObject:_button];
            
            [self addSubview:_button];
            
        }
        [self setSegmentIndex:0];
        
    }
    return self;
}

-(void)buttonFont:(UIFont *)font{
    _button.titleLabel.font = font;

}
-(void)setSegmentIndex:(NSInteger)index
{
    _selectedSegmentIndex = index;
    [self segmentAction:[segmentButtons objectAtIndex:index]];
}

-(void)segmentAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag =  button.tag;
    for(int i=0; i<[segmentButtons count]; i++){
        int nameOffset = SEGMENT_UNSELECTED;
        if (tag == i) {
            nameOffset = SEGMENT_SELECTED;
        }
        UIButton *segButton = [segmentButtons objectAtIndex:i];
        [segButton setBackgroundImage:[UIImage imageNamed:[buttonImgNames objectAtIndex:i*2+nameOffset]]
                             forState:UIControlStateNormal];
        
        
        [segButton setTitleColor:[UIColor colorWithRed:92./255 green:92./255 blue:92./255 alpha:1.0f] forState:UIControlStateNormal];
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        segButton.titleLabel.font = font;
        //[segButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        if(_selectedSegmentIndex)
        {
            [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];

        }
        [segButton addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventTouchUpInside];
        if(i==0){
            [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        }
       
        
    }
}

- (void)changeSeg:(UIButton *)sender
{
    UIButton *button = (UIButton*)sender;
    [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];

    self.changeSegBtnIndex(sender.tag);
}
@end
