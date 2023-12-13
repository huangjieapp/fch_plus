//
//  showLikeProductView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/15.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "showLikeProductView.h"

#define rowNumber (self.style==showLikeProductViewNew)?4:3
#define viewWidth (self.style==showLikeProductViewNew)?(KScreenWidth-40):(KScreenWidth-80)



@interface showLikeProductView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView*mainView;

@property(nonatomic,strong)NSMutableArray*allDatas; //这个只是第一次 接收所有数据的
@property(nonatomic,strong)NSMutableArray*datasArray; //这个是用来 显示和修改的


@property(nonatomic)showLikeProductViewStyle style;

@property(nonatomic,strong)UILabel * numberLabel;

@property(nonatomic)NSInteger number;

@end

@implementation showLikeProductView


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHidden)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
       
        
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame withType:(showLikeProductViewStyle)style{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
        self.style=style;
        self.number=1;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHidden)];
        tap.delegate=self;
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
    
}




-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.mainView]) {
        return NO;
    }
    return YES;
}


-(void)getShowValue:(NSMutableArray*)allDatas{
    [self.mainView removeFromSuperview];
    self.mainView=nil;
    
    //给他赋值
    _allDatas=allDatas;
    
    //真正用来显示 用的
    self.datasArray=[NSMutableArray array];
    for ( CodeShoppingModel*model in allDatas) {
        if ([model.isStatus isEqualToString:@"delete"]) {
            
        }else{
            [self.datasArray addObject:model];
        }
        
    }
    
  
    
    self.mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,viewWidth , 200)];//KScreenWidth-80
   
 
    self.mainView.centerX=self.centerX;
    self.mainView.centerY=self.centerY;
    self.mainView.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.mainView];
    
   
    
    UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    if (self.style==showLikeProductViewNew) {
        topView.frame=CGRectMake(0, 0, KScreenWidth-40, 60);
    }
    [self.mainView addSubview:topView];
    
    
    
    UILabel*label0=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, topView.width/(rowNumber), 25)];
    label0.textAlignment=NSTextAlignmentCenter;
    label0.textColor=[UIColor grayColor];
    label0.text=@"编号";
    [topView addSubview:label0];
    UILabel*label1=[[UILabel alloc]initWithFrame:CGRectMake(topView.width/(rowNumber), 20, topView.width/(rowNumber), 25)];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.textColor=[UIColor grayColor];
    label1.text=@"产品";
    [topView addSubview:label1];
    UILabel*label2=[[UILabel alloc]initWithFrame:CGRectMake(topView.width/(rowNumber)*2, 20, topView.width/(rowNumber), 25)];
    label2.textAlignment=NSTextAlignmentCenter;
    label2.textColor=[UIColor grayColor];
    label2.text=@"价格";
    [topView addSubview:label2];

    if (self.style==showLikeProductViewNew) {
        UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(topView.width/(rowNumber)*3, 20, topView.width/(rowNumber), 25)];
        label3.textAlignment=NSTextAlignmentCenter;
        label3.textColor=[UIColor grayColor];
        label3.text=@"数量";
        [topView addSubview:label3];
    }
    
    
    UIView*lastInfoView;   //最后一条信息   用来改变
    for (int i=0; i<self.datasArray.count; i++) {
        CodeShoppingModel*model=self.datasArray[i];
        
        UIView*infoView=[[UIView alloc]initWithFrame:CGRectMake(0, 60+i*20, self.mainView.width, 20)];
        [self.mainView addSubview:infoView];
        lastInfoView=infoView;
        
        UILabel*infoLabel0=[[UILabel alloc]initWithFrame:CGRectMake(0, 2.5, infoView.width/(rowNumber), 15)];
        infoLabel0.textAlignment=NSTextAlignmentCenter;
        infoLabel0.font=[UIFont systemFontOfSize:14];
        infoLabel0.textColor=[UIColor blackColor];
        infoLabel0.text=model.C_PRODUCTCODE;
        [infoView addSubview:infoLabel0];
        
        UILabel*infoLabel1=[[UILabel alloc]initWithFrame:CGRectMake(infoView.width/(rowNumber), 2.5, infoView.width/(rowNumber), 15)];
        infoLabel1.textAlignment=NSTextAlignmentCenter;
        infoLabel1.font=[UIFont systemFontOfSize:14];
        infoLabel1.textColor=[UIColor blackColor];
        infoLabel1.text=model.C_A41900_C_NAME;
        [infoView addSubview:infoLabel1];
        
        UILabel*infoLabel2=[[UILabel alloc]initWithFrame:CGRectMake(infoView.width/(rowNumber)*2, 2.5, infoView.width/(rowNumber), 15)];
        infoLabel2.textAlignment=NSTextAlignmentCenter;
        infoLabel2.font=[UIFont systemFontOfSize:14];
        infoLabel2.textColor=[UIColor blackColor];
        infoLabel2.text=model.B_PRICE;
        [infoView addSubview:infoLabel2];
        
        UIView *numView=[[UIView alloc] initWithFrame:CGRectMake(infoView.width/(rowNumber)*3, 0, infoView.width/(rowNumber), 20)];
        numView.backgroundColor=[UIColor whiteColor];
        if (self.style==showLikeProductViewNew) {
            [infoView addSubview:numView];
        }
        
        CGFloat numWidth=numView.width/3;
        
        UIButton * addButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, numWidth, 20)];
        [addButton setTitle:@"+" forState:UIControlStateNormal];
        addButton.tag=800+i;
        [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(changeNumber:)];
        [numView addSubview:addButton];

        UILabel * numLab=[[UILabel alloc]initWithFrame:CGRectMake(numWidth, 0, numWidth, 20)];
        numLab.textAlignment=NSTextAlignmentCenter;
        numLab.font=[UIFont systemFontOfSize:14];
        numLab.textColor=[UIColor blackColor];
        numLab.text=[NSString stringWithFormat:@"%ld",(long)self.number];
        self.numberLabel=numLab;
//        numLab.text=model.B_PRICE;
        [numView addSubview:self.numberLabel];
        
        UIButton * minusButton=[[UIButton alloc]initWithFrame:CGRectMake(numWidth*2, 0, numWidth, 20)];
        [minusButton setTitle:@"-" forState:UIControlStateNormal];
        [minusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        minusButton.tag=800+i;
        [minusButton addTarget:self action:@selector(changeNumber:)];
        [numView addSubview:minusButton];

        
        
        
        
        UIButton*deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 2.5, 15, 15)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_product"] forState:UIControlStateNormal];
        deleteButton.tag=1000+i;
        [deleteButton addTarget:self action:@selector(clickDeleteOneInfo:)];
        [infoView addSubview:deleteButton];

        
        
        
    }
    
    NSInteger bottomValue=CGRectGetMaxY(lastInfoView.frame);   //最后一条数组的底
    if (!bottomValue) {
        bottomValue=50;
    }
    NSInteger topButtonView=bottomValue+20;   //按钮view 的顶
    
    
    UIView*buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, topButtonView, self.mainView.width, 50)];
    [self.mainView addSubview:buttonView];
    UIView*horLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mainView.width, 1)];
    horLine.backgroundColor=[UIColor grayColor];
    [buttonView addSubview:horLine];
    UIView*verLine0=[[UIView alloc]initWithFrame:CGRectMake(self.mainView.width/3, 0, 1, 50)];
    verLine0.backgroundColor=[UIColor grayColor];
    [buttonView addSubview:verLine0];
    UIView*verLine1=[[UIView alloc]initWithFrame:CGRectMake(self.mainView.width/3*2, 0, 1, 50)];
    verLine1.backgroundColor=[UIColor grayColor];
    [buttonView addSubview:verLine1];
    NSArray*localArray=@[@"取消",@"继续扫码",@"完成"];
    for (int i=0; i<localArray.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(self.mainView.width/3*i, 12.5, self.mainView.width/3, 25)];
        [button setTitle:localArray[i]];
        button.tag=100+i;

        [button setTitleColor:[UIColor blackColor]];
//        [button setBackgroundColor:KNaviColor];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(clickBottomButton:)];
        [buttonView addSubview:button];
        
    }
  
    
    //按钮的view的高是50
//    self.mainView.frame.size=CGSizeMake(KScreenWidth-80, topButtonView+50);
    self.mainView.width=viewWidth;
    self.mainView.height=topButtonView+50;
    self.mainView.centerX=self.centerX;
    self.mainView.centerY=self.centerY;
    
  
    
}




#pragma mark  --touch
-(void)clickHidden{
    self.hidden=YES;
    
}


- (void)changeNumber:(UIButton *)btn{

    if ([btn.title isEqualToString:@"+"]) {
        self.number+=1;
        if (self.addBtnBlock) {
            self.addBtnBlock();
        }
    }
    if ([btn.title isEqualToString:@"-"]) {
        if (self.number==1) {
            return;
        }
        self.number-=1;
        if (self.minusBtnBlock) {
            self.minusBtnBlock();
        }
    }

    self.numberLabel.text=[NSString stringWithFormat:@"%ld",(long)self.number];
}


-(void)clickDeleteOneInfo:(UIButton*)sender{
    NSInteger tag=sender.tag-1000;
    MyLog(@"删除某一条数据,上个界面的能被删掉？");
    
    //删除之前 先copy这个model 改状态 再代理回去
    CodeShoppingModel*Model=self.datasArray[tag];

    Model.isStatus=@"delete";
    if (self.deleteModelBlock) {
        self.deleteModelBlock(Model);
    }
    
    
//    [self.allDatas removeObjectAtIndex:tag];
    
    
    
    [self getShowValue:self.allDatas];
    
    
}


-(void)clickBottomButton:(UIButton*)sender{
    NSInteger tag=sender.tag-100;
    MyLog(@"%lu",tag);
    switch (tag) {
        case 0:{
            //取消
            [self clickHidden];
            
            break;}
        case 1:{
            //继续扫描
            [self clickHidden];
            if (self.continueSanfBlock) {
                self.continueSanfBlock();
            }
            
            break;}
        case 2:{
            //完成
            [self clickHidden];
            if (self.completeBlock) {
                self.completeBlock(self.allDatas);
            }
            
            break;}

            
        default:
            break;
    }
    
    
    
    
    
    
    
}


@end
