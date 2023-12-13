//
//  CustomLabelTableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/4.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CustomLabelTableViewCell.h"
#import "labelCustomButton.h"



@interface CustomLabelTableViewCell()
@property(nonatomic,strong)NSMutableArray*saveAllLabelArray;   //保存所有的button  用来移除




@end

@implementation CustomLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth/2, 15)];
        titleLabel.text=@"饮水偏好";
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textColor=DBColor(160, 160, 160);
        self.titleLabel=titleLabel;
        [self.contentView addSubview:titleLabel];

        
    }
    return  self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the view for the selected state
}

#pragma mark  --click
-(void)clickButton:(labelCustomButton*)sender{
    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
    
    NSInteger number=sender.tag-1000;
    CustomLabelModel*model=self.labelArray[number];
    
    //model 的isSelected 是bool 类型
    model.isSelected=sender.selected;
    

    if (self.getclickButtonBlock) {
        self.getclickButtonBlock(model, model.isSelected);
    }
    
    
}


#pragma mark  --set
-(void)setLabelArray:(NSArray *)labelArray{
    _labelArray=labelArray;
    
    //先移除
    for (labelCustomButton*button in self.saveAllLabelArray) {
        [button removeFromSuperview];
    }
    [self.saveAllLabelArray removeAllObjects];
    
    // 从30 的地方开始
    NSInteger topValue=30;
    NSInteger leftValue=20;
    NSInteger horizontalSpace=10;
    NSInteger verticalSpace=10;
    NSInteger maxWith=KScreenWidth-20-20;  //最后一个减少20是 偏移
    
    for (int i=0; i<_labelArray.count; i++) {
        CustomLabelModel*model=_labelArray[i];
        
        
        NSString*title=model.title;
        UIColor*currentColor=model.currentColor;
        BOOL isSelected=model.isSelected;
        
        CGFloat labelButtonHeight=20;
        CGFloat labelButtonWith=[title boundingRectWithSize:CGSizeMake(maxWith, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+10;   //左右个余留了5 
        if ((leftValue+labelButtonWith)<=maxWith) {
            
            
        }else{
            topValue=topValue+verticalSpace+labelButtonHeight;
            leftValue=20;
        }
        
        
        
        
        labelCustomButton*button=[[labelCustomButton alloc]init];
        button.tag=1000+i;
        [button setTitle:title forState:UIControlStateNormal];
        button.layer.borderColor=currentColor.CGColor;
        [button addTarget:self action:@selector(clickButton:)];
        
        [button setTitleColor:currentColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:currentColor size:CGSizeMake(1.0, 1.0)] forState:UIControlStateSelected];
        
        
        button.frame=CGRectMake(leftValue, topValue, labelButtonWith, labelButtonHeight);
        [self.contentView addSubview:button];
        button.selected=isSelected;
        
        
        
        //这里结束之后要给他赋值的
        leftValue=leftValue+labelButtonWith+horizontalSpace;
        
        
        //保存所有的东西
        [self.saveAllLabelArray addObject:button];
        
        
    }
    
    
       
    
    
}

//保存所有的button
-(NSMutableArray *)saveAllLabelArray{
    if (!_saveAllLabelArray) {
        _saveAllLabelArray=[NSMutableArray array];
    }
    return _saveAllLabelArray;
}




#pragma mark  -- function
+(CGFloat)cellHeightWithArray:(NSArray*)labelArray{

    
    // 从30 的地方开始
    NSInteger topValue=30;
    NSInteger leftValue=20;
    NSInteger horizontalSpace=10;
    NSInteger verticalSpace=10;
    NSInteger maxWith=KScreenWidth-20-20;  //最后一个减少20是 偏移
    
    for (int i=0; i<labelArray.count; i++) {
        CustomLabelModel*model=labelArray[i];
        
        
        NSString*title=model.title;
        UIColor*currentColor=model.currentColor;
        BOOL isSelected=model.isSelected;

        
        
        CGFloat labelButtonHeight=20;
        CGFloat labelButtonWith=[title boundingRectWithSize:CGSizeMake(maxWith, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+10;   //左右个余留了5
        if ((leftValue+labelButtonWith)<=maxWith) {
            
            
        }else{
            topValue=topValue+verticalSpace+labelButtonHeight;
            leftValue=20;
        }
        
        
        
        
        
        //这里结束之后要给他赋值的
        leftValue=leftValue+labelButtonWith+horizontalSpace;
        
    }

    return topValue+20+10;   //20是文字的高  10 是底部再来点高
}







@end
