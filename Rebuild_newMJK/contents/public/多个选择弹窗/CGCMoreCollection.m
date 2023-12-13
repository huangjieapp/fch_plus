//
//  CGCMoreCollection.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCMoreCollection.h"

@interface CGCMoreCollection()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *picArray;

@property (nonatomic, copy) NSString * titleStr;

@property (nonatomic, strong) UIButton *bgButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) SELECTINDEX selBlock;
@end

@implementation CGCMoreCollection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame withPicArr:(NSArray *)picArr withTitleArr:(NSArray *)titleArr withTitle:(NSString *)title withSelectIndex:(SELECTINDEX)sel{

    if (self=[super initWithFrame:frame]) {
        
        self.dataArray=[NSMutableArray arrayWithArray:titleArr];
        self.picArray=[NSMutableArray arrayWithArray:picArr];
        self.titleStr=title;
        self.selBlock = sel;
        [self createUI];
        
    }

    return self;
}


- (void)createUI{
    NSInteger countT=self.dataArray.count>4?4:self.dataArray.count;
    
    
    CGFloat BHight=160;
    NSLog(@"%d---%d",2%4,5%4);
    
//    if (self.dataArray.count % 4 == 0) {
//    BHight = (100 * (self.dataArray.count / 4)) + BHight;
    
//    }
    
    if (self.dataArray.count/4==0&&self.dataArray.count/4==1) {
         BHight=160;
    }
    if (self.dataArray.count>4) {
        BHight=260;
    }
    if (self.dataArray.count>8) {
        BHight=360;
    }
    UIView * bview=[[UIView alloc] initWithFrame:CGRectMake(10,150, KScreenWidth-20, BHight)];
    bview.backgroundColor=DBColor(255, 255, 255);
    UIButton * bgBtn=[self getBtnWithFrame:self.bounds withTitleStr:nil WithImgStr:nil withTag:111];
    bgBtn.backgroundColor=CGCBGCOLOR;
    [self addSubview:bgBtn];
    self.bgButton=bgBtn;
    
    UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, bview.width, 20)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.font=[UIFont systemFontOfSize:14];
   
    lab.text=self.titleStr;
    [bview addSubview:lab];
    
   
    for (int i=0; i<self.dataArray.count; i++) {
      
       CGFloat textW= [DBObjectTools getTheWeithWithText:self.dataArray[i] withSize:12];
      
     
        
        CGFloat bx=((KScreenWidth-20)-20*(countT+1))/countT*(i%4)+((i%4)+1)*20;
        CGFloat bw=((KScreenWidth-20)-20*(countT+1))/countT;
        CGFloat by=50 + (i/4) * 100;
//        if (i<=3) {
//            by=50;
//        }else{
//           by=160;
//        }
        CGRect rect=CGRectMake(bx, by, bw, 50);
        
        NSString * imgUrl=self.picArray.count>i?self.picArray[i]:@"";
        
        UIButton * btn=[self getBtnWithFrame:rect withTitleStr:nil WithImgStr:imgUrl withTag:i+100];
        UILabel * lab=[[UILabel alloc] init];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:11];
        lab.textColor=DBColor(102, 102, 102);
        lab.text=self.dataArray[i];
        lab.centerX=btn.centerX-textW/2;
       
        lab.y=CGRectGetMaxY(btn.frame)+10;
      
        lab.height=20;
        lab.width=textW;
        [bview addSubview:lab];
        [bview addSubview:btn];
    }
    [self addSubview:bview];

}


- (UIButton *)getBtnWithFrame:(CGRect)frame withTitleStr:(NSString *)title WithImgStr:(NSString *)imgStr withTag:(NSInteger)tag{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.x=frame.origin.x;
    btn.y=frame.origin.y;
    btn.size=frame.size;
    [btn setTitleNormal:title];
    [btn setImage:imgStr];
   
    btn.tag=tag;
    [btn addTarget:self action:@selector(btnClick:)];
    return btn;
}


- (void)btnClick:(UIButton *)btn{
   
    NSString *str=self.dataArray.count>(btn.tag-100)?self.dataArray[btn.tag-100]:@"";
  

    if (self.selBlock) {
        self.selBlock(btn.tag-100,str);
    }
    
   [self removeFromSuperview];
}






- (NSMutableArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }

    return _dataArray;
}


- (NSMutableArray *)picArray{
    
    if (!_picArray) {
        
        _picArray=[NSMutableArray array];
    }
    
    return _picArray;
}





@end
