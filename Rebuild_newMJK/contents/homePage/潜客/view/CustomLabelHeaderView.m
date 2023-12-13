//
//  CustomLabelHeaderView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CustomLabelHeaderView.h"
#import "labelCustomButton.h"
#import "CustomLabelModel.h"

@interface CustomLabelHeaderView()
//还是要先移除所有的button
@property(nonatomic,strong)NSMutableArray*saveAllLabelArray;

@end

@implementation CustomLabelHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIView*BGView=[[UIView alloc]init];
    BGView.backgroundColor=[UIColor whiteColor];
    self.backgroundView=BGView;
   
    
    
}



#pragma mark  --set

-(void)setAllLabelArray:(NSMutableArray *)allLabelArray{
    _allLabelArray=allLabelArray;
    
    //先移除
    for (labelCustomButton*button in self.saveAllLabelArray) {
        [button removeFromSuperview];
    }
    [self.saveAllLabelArray removeAllObjects];

    
    
    
    CGFloat topValue=90;
    CGFloat leftValue=20;
    CGFloat horizonalSpace=10;
    CGFloat verticalSpace=10;
    CGFloat maxWith=KScreenWidth-20-20;
    
    
    for (CustomLabelModel*model in allLabelArray) {
        NSString*title=model.title;
        UIColor*currentColor=model.currentColor;
        
        CGFloat itemWith=[title boundingRectWithSize:CGSizeMake(maxWith, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+5+5;
        CGFloat itemHeight=15;
        
        
        
         //底是80    需要加个10
        if (leftValue+itemWith<=maxWith) {
            
        }else{
            topValue=topValue+itemHeight+verticalSpace;
            leftValue=20;
        }
        
        //创建button
        labelCustomButton*button=[[labelCustomButton alloc]init];
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.borderColor=currentColor.CGColor;

        
        [button setTitleColor:currentColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:currentColor size:CGSizeMake(1.0, 1.0)] forState:UIControlStateSelected];
        
        
        button.frame=CGRectMake(leftValue, topValue, itemWith, itemHeight);
        [self addSubview:button];
        
        
        
        
        //这里结束之后要给他赋值的
        leftValue=leftValue+itemWith+horizonalSpace;
        
        
        //保存所有的东西
        [self.saveAllLabelArray addObject:button];
        
        
        
        
        
        
        
        
        
        
    }
    

    
}

-(NSMutableArray *)saveAllLabelArray{
    if (!_saveAllLabelArray) {
        _saveAllLabelArray=[NSMutableArray array];
    }
    return _saveAllLabelArray;
}




#pragma mark  -- funcation
+(CGFloat)headerHeight:(NSArray*)array{
    CGFloat topValue=90;
    CGFloat leftValue=20;
    CGFloat horizonalSpace=10;
    CGFloat verticalSpace=10;
    CGFloat maxWith=KScreenWidth-20-20;
    
    
    for (CustomLabelModel*model in array) {
        NSString*title=model.title;
        UIColor*currentColor=model.currentColor;
        
        CGFloat itemWith=[title boundingRectWithSize:CGSizeMake(maxWith, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+5+5;
        CGFloat itemHeight=15;
        
        
        
        //底是80    需要加个10
        if (leftValue+itemWith<=maxWith) {
            
        }else{
            topValue=topValue+itemHeight+verticalSpace;
            leftValue=20;
        }
 
        
        //这里结束之后要给他赋值的
        leftValue=leftValue+itemWith+horizonalSpace;

        
     
   
}
    
   
    if (array.count<1) {
        return topValue;
    }
    return topValue+20+10;
    
}


@end
