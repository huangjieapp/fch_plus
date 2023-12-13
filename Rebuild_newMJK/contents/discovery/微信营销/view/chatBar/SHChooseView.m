//
//  SHChooseView.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/1.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHChooseView.h"

@interface SHChooseView()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,strong) NSMutableArray *picArray;

@end


@implementation SHChooseView


-(instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArr withPicArr:(NSArray *)picArr withSel:(SHSELBLOCK )selB{
    self=[super initWithFrame:frame];
    if (self) {
      
        self.dataArray=[NSMutableArray arrayWithArray:dataArr];
        self.picArray=[NSMutableArray arrayWithArray:picArr];
        self.selBlock = selB;
        [self createUI];
    }
    return self;
    
}

- (void)createUI{
    NSInteger countT=self.dataArray.count>4?4:self.dataArray.count;
    
 
    UIView * bview=[[UIView alloc] initWithFrame:self.bounds];
    bview.backgroundColor=DBColor(255, 255, 255);
 
    for (int i=0; i<self.dataArray.count; i++) {
        
        CGFloat textW= [DBObjectTools getTheWeithWithText:self.dataArray[i] withSize:12];
        
        
        
        CGFloat bx=(KScreenWidth-20*(countT+1))/countT*(i%4)+((i%4)+1)*20;
        CGFloat bw=(KScreenWidth-20*(countT+1))/countT;
        CGFloat by=15;
        if (i<=3) {
            by=15;
        }else{
            by=110;
        }
        CGRect rect=CGRectMake(bx, by, bw, 50);
        
        NSString * imgUrl=self.picArray.count>i?self.picArray[i]:@"";
        
        UIButton * btn=[self getBtnWithFrame:rect withTitleStr:nil WithImgStr:imgUrl withTag:i+100];
        UILabel * lab=[[UILabel alloc] init];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:12];
        lab.textColor=DBColor(0, 0, 0);
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
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    btn.tag=tag;
    [btn addTarget:self action:@selector(btnClick:)];
    return btn;
}

- (void)btnClick:(UIButton *)btn{
    
    NSString *str=self.dataArray.count>(btn.tag-100)?self.dataArray[btn.tag-100]:@"";
    
    
    if (self.selBlock) {
        self.selBlock(str,btn);
    }
    
    
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
