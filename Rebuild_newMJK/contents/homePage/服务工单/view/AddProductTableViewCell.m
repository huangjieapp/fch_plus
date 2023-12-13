//
//  AddProductTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/31.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "AddProductTableViewCell.h"
@interface AddProductTableViewCell()
@property(nonatomic,strong)UILabel*titleLab;

@property(nonatomic,strong)UIView*infoMainView;   //材料信息下面的所有主视图

@end


@implementation AddProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        topView.backgroundColor=DBColor(247, 247, 247);
        [self.contentView addSubview:topView];
        UILabel*titleLab=[[UILabel alloc]initWithFrame:CGRectMake(12, 12.5, 70, 15)];
        self.titleLab=titleLab;
        titleLab.text=@"材料信息";
        titleLab.font=[UIFont systemFontOfSize:14];
        titleLab.textColor=DBColor(154, 154, 154);
        [topView addSubview:titleLab];
        UIButton*addButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-15-20, 7, 20, 20)];
        [addButton setBackgroundImage:[UIImage imageNamed:@"icon_customer_details_add_lable"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(clickAddInfo)];
        [topView addSubview:addButton];
        
        
        
        
    }
    return self;
    
}



#pragma mark  --click
-(void)deleteOneInfo:(UIGestureRecognizer*)tap{
    UIView*subView=tap.view;
    NSInteger number=subView.tag-100;
    if (self.DeleteOneInfoBlock) {
        self.DeleteOneInfoBlock(number);
    }
    
}



-(void)clickAddInfo{
    //
    if (self.clickAddInfoButtonBlock) {
        self.clickAddInfoButtonBlock(self.titleStr);
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

#pragma mark  --set
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr=titleStr;
    self.titleLab.text=titleStr;
    
}


-(void)setDatasArray:(NSMutableArray *)datasArray{
    _datasArray=datasArray;
    if (self.infoMainView) {
        [self.infoMainView removeFromSuperview];
        self.infoMainView=nil;
    }
    
    if (datasArray.count<1) {
        return;
    }
    
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, ([AddProductTableViewCell getCellHeight:datasArray]-40))];
    self.infoMainView=mainView;
    mainView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:mainView];
    
    UIView*fourTitleView=[self subCellViewWithTop:0 andFirstName:@"名称" andSecondName:@"价格" andThirdName:@"数量" andTotailName:@"小计"];
    [mainView addSubview:fourTitleView];
    
    
    CGFloat totailPrice=0;
    for (int i=0; i<datasArray.count; i++) {
        ProductInfoModel*model=datasArray[i];
        CGFloat topValue=i*40+40;
        UIView*subView=[self subCellViewWithTop:topValue andFirstName:model.C_NAME andSecondName:model.B_PRICE andThirdName:model.I_NUMBER andTotailName:model.B_SUBTOTAL];
        [mainView addSubview:subView];
        subView.tag=100+i;
        totailPrice=totailPrice+[model.B_SUBTOTAL floatValue];
        
        //tap
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteOneInfo:)];
        [subView addGestureRecognizer:tap];
        
        
    }
    
    //底部的title
    UILabel*bottomLabel=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/2, mainView.height-30, KScreenWidth/2-12, 15)];
    bottomLabel.font=[UIFont systemFontOfSize:14];
    bottomLabel.textAlignment=NSTextAlignmentRight;
    bottomLabel.text=[NSString stringWithFormat:@"合计:%.2f",totailPrice];
    [mainView addSubview:bottomLabel];
    
    
}



#pragma mark  -- funcation
-(UIView*)subCellViewWithTop:(CGFloat)topValue andFirstName:(NSString*)firstName andSecondName:(NSString*)secondName andThirdName:(NSString*)thirdName andTotailName:(NSString*)fourthName{
    NSArray*array=@[firstName,secondName,thirdName,fourthName];
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, topValue, KScreenWidth, 40)];
    mainView.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<4; i++) {
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/4*i, 0, KScreenWidth/4, 40)];
        label.font=[UIFont systemFontOfSize:14];
        label.textAlignment=NSTextAlignmentCenter;
        [mainView addSubview:label];
        label.text=array[i];
  
    }
    
    UIView*bottomLineView=[[UIView alloc]initWithFrame:CGRectMake(15, mainView.height-1, KScreenWidth-15-15, 1)];
    bottomLineView.backgroundColor=DBColor(238, 238, 238);
    [mainView addSubview:bottomLineView];

    
    return mainView;
}



+(CGFloat)getCellHeight:(NSMutableArray *)datasArray{
    if (datasArray.count<1) {
        return 40;
    }else{
        NSInteger number=datasArray.count;
        return 40+40+40+40*number;
        
    }
    
   
}


@end
