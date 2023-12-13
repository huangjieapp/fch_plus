//
//  CGCGoodsDetailView.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/25.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCGoodsDetailView.h"

#import "CGCGoodsFootView.h"
#import "CGCGoodsDetailCell.h"

#import "CodeShoppingModel.h"

@interface CGCGoodsDetailView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) CGCGoodsFootView * footView;

@property (nonatomic,strong) UILabel * priLab;

@end

@implementation CGCGoodsDetailView

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self=[super initWithFrame:frame]) {
       
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=self.bounds;
        [btn addTarget:self action:@selector(canelClick:)];
        [self addSubview:btn];
        
        self.backgroundColor=CGCBGCOLOR;
        [self addSubview:self.tableView];
    }
    
    return self;
}

- (void)keyboardHide{
    [self removeFromSuperview];
}
- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] init];
        _tableView.frame=CGRectMake(20, 100, KScreenWidth-40, 120+self.dataArray.count*30);
//        _tableView.size=CGSizeMake(KScreenWidth-40, 100+2*44);
        _tableView.center=self.center;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        [self createFootWithHead];
    }

    return _tableView;
}

- (CGCGoodsFootView *)footView{

    if (_footView==nil) {
        _footView=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCGoodsFootView class]) owner:self options:nil] lastObject];
    }
    return _footView;
    
}

- (void)createFootWithHead{

    
    self.tableView.tableFooterView=self.footView;
    [self.footView.canelBtn addTarget:self action:@selector(canelClick:)];
    [self.footView.countieBtn addTarget:self action:@selector(continueClick:)];
    [self.footView.finishBtn addTarget:self action:@selector(finishClick:)];
    
    
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-40, 40)];
    view.backgroundColor=[UIColor whiteColor];
    CGFloat labW=view.width/4;
     for (int i=0; i<4; i++) {
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(i*labW, 0, labW, 40)];
         lab.text=@[@"编号",@"产品",@"价格",@"数量"][i];
         lab.textAlignment=NSTextAlignmentCenter;
         lab.textColor=[UIColor grayColor];
         [view addSubview:lab];
         
    }
    self.tableView.tableHeaderView=view;

}

- (void)canelClick:(UIButton *)btn{

    if (self.canelB) {
        self.canelB();
    }
    [self removeFromSuperview];
}
- (void)continueClick:(UIButton *)btn{
    if (self.cont) {
        self.cont();
    }
    
}
- (void)finishClick:(UIButton *)btn{
    
    if (self.finish) {
        self.finish();
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGCGoodsDetailCell * cell=[CGCGoodsDetailCell cellWithTableView:tableView];
    [cell.addBtn addTarget:self action:@selector(addBtnclick:)];
    [cell.minsBtn addTarget:self action:@selector(minsBtnclick:)];
    [cell.delBtn addTarget:self action:@selector(delRow:)];
    cell.delBtn.tag=cell.minsBtn.tag=cell.addBtn.tag=indexPath.row;
 
    
    CodeShoppingModel * model=self.dataArray[indexPath.row];
    [cell reloadCellWithModel:model];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
//    view.backgroundColor=[UIColor redColor];
    
    UIView * line= [[UIView alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth-60, 1)];
    line.backgroundColor=CGCNAVCOLOR;
    [view addSubview:line];
    
    UILabel * left=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100, 30)];
    left.text=[NSString stringWithFormat:@"共 %lu 件",(unsigned long)self.dataArray.count];
    left.textAlignment=NSTextAlignmentCenter;
    left.font=[UIFont systemFontOfSize:14];
    left.textColor=CGCNAVCOLOR;
    
    UILabel * right=[[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-200, 10, 200, 30)];
    double priceText=0.00;
    for (CodeShoppingModel * model in self.dataArray) {
        priceText+=[model.B_PRICE doubleValue]*[model.I_NUMBER intValue];
    }
    right.text=[NSString stringWithFormat:@"%.2f",priceText];
    right.textAlignment=NSTextAlignmentCenter;
    right.font=[UIFont systemFontOfSize:14];
    right.textColor=CGCNAVCOLOR;
    
    [view addSubview:left];
    [view addSubview:right];
    self.priLab=right;


    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 40;
}

- (void)addBtnclick:(UIButton *)btn{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:btn.tag inSection:0];
    CGCGoodsDetailCell * cell=[self.tableView cellForRowAtIndexPath:indexPath];
    int num = [cell.geshuLab.text intValue];
    num+=1;
    NSString * str= [NSString stringWithFormat:@"%d",num];
    cell.geshuLab.text=str;
    [self getNumberWith:indexPath withNum:str];
    double priceText=0.00;
    for (CodeShoppingModel * model in self.dataArray) {
        priceText+=[model.B_PRICE doubleValue]*[model.I_NUMBER intValue];
    }
    
    self.priLab.text=[NSString stringWithFormat:@"%.2f",priceText];

}
- (void)minsBtnclick:(UIButton *)btn{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:btn.tag inSection:0];
    CGCGoodsDetailCell * cell=[self.tableView cellForRowAtIndexPath:indexPath];
    int num = [cell.geshuLab.text intValue];
    if (num>1) {
       num-=1;
    }
    NSString * str= [NSString stringWithFormat:@"%d",num];
    cell.geshuLab.text=str;
    [self getNumberWith:indexPath withNum:str];
    double priceText=0.00;
    for (CodeShoppingModel * model in self.dataArray) {
        priceText+=[model.B_PRICE doubleValue]*[model.I_NUMBER intValue];
    }
    
    self.priLab.text=[NSString stringWithFormat:@"%.2f",priceText];

}

- (void)delRow:(UIButton *)btn{
    NSLog(@"%d----",btn.tag);
    if (self.dataArray.count>0&&self.dataArray.count>btn.tag) {
        [self.dataArray removeObjectAtIndex:btn.tag];
        [self reloadTable];
    }
    
    if (self.del) {
        self.del(btn.tag);
    }

}



- (void)getNumberWith:(NSIndexPath *)indexPath withNum:(NSString *)num{

    CodeShoppingModel * model=self.dataArray[indexPath.row];
      model.I_NUMBER=num;

}



- (void)reloadTable{
    self.tableView.height= 120+self.dataArray.count*30;
    [self.tableView reloadData];
}
@end
