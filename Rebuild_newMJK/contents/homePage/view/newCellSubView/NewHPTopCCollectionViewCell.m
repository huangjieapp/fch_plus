//
//  NewHPTopCCollectionViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/8/2.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "NewHPTopCCollectionViewCell.h"
#import "newPHDefinedButton.h"


@interface NewHPTopCCollectionViewCell()
@property(nonatomic,strong)UIScrollView*mainScrollView;
@end

@implementation NewHPTopCCollectionViewCell



-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
//        self.layer.borderWidth=1;
//        self.layer.borderColor=[UIColor grayColor].CGColor;
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        

        
        
    }
    return self;
    
}


-(void)inputValue:(NextCountModel*)mainModel{
    self.mainModel=mainModel;
    NSString*titleStr=mainModel.TYPE;
    NSArray*allArray=mainModel.content;
    
    

#warning     排序的话  排序好了 点击的时候 要用排序好的参数 来选tag 不然有bug
    NSArray*result=allArray;
    
    
    //这个东西 需要降序排列
    //对数组进行排序
    
//    //这里类似KVO的读取属性的方法，直接从字符串读取对象属性，注意不要写错
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"COUNT" ascending:YES];
//    //这个数组保存的是排序好的对象
//    NSArray *result = [allArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
//    
//    for(NSInteger i = 0; i < [result count]; i++)
//    {
//        NSLog(@"%@--------%@\n", [[result objectAtIndex:i] NAME], [[result objectAtIndex:i] COUNT]);
//    }
    
    

//    NSArray *result = [allArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        
//        subDicNextCountModel *pModel1 = obj1;
//        subDicNextCountModel *pModel2 = obj2;
//        
//        
//        //按照年龄排序
//        if (pModel1.COUNT > pModel2.COUNT) { //不使用intValue比较无效
//            return NSOrderedDescending;//降序
//        }else if (pModel1.COUNT < pModel2.COUNT){
//            return NSOrderedAscending;//升序
//        }else {
//            return NSOrderedSame;//相等
//        }  
//        
//    }];  

    
    
    
    [self.mainScrollView removeFromSuperview];
    self.mainScrollView=nil;
    
    UIScrollView*scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.mainScrollView=scrollView;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.bounces=NO;
    scrollView.contentSize=CGSizeMake(result.count*ACTUAL_WIDTH(80), 0);
    [self.contentView addSubview:scrollView];
    
    //颜色的
    UIView*rightColorView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, self.frame.size.height)];
    rightColorView.backgroundColor=[UIColor redColor];
    if ([titleStr isEqualToString:@"今日待办任务"]) {
        rightColorView.backgroundColor=DBColor(107, 243, 205);
    }else if ([titleStr isEqualToString:@"后三天待办任务"]){
        rightColorView.backgroundColor=DBColor(253,186,80);
    }else{
        rightColorView.backgroundColor=DBColor(253, 136, 150);
    }
    
    
    [scrollView addSubview:rightColorView];
    //顶上的文字
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(ACTUAL_WIDTH(15), ACTUAL_HEIGHT(5), KScreenWidth/2, ACTUAL_HEIGHT(15))];
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.text=titleStr;
    [scrollView addSubview:titleLabel];
    
    
    for (int i=0; i<result.count; i++) {
        
        
        newPHDefinedButton*button=[newPHDefinedButton newPHDefinedButton];
        button.frame=CGRectMake(i * (KScreenWidth  / 5), ACTUAL_HEIGHT(25), ACTUAL_WIDTH(KScreenWidth  / 5), ACTUAL_HEIGHT(30));
        if (i==0) {
            button.frame=CGRectMake(ACTUAL_WIDTH(10), ACTUAL_HEIGHT(25), ACTUAL_WIDTH(60), ACTUAL_HEIGHT(30));
        }
        
        [button addTarget:self action:@selector(clickDefineButton:)];
       
        
        
        button.tag=1000+i;
        [scrollView addSubview:button];
        subDicNextCountModel*subModel=result[i];
        button.topNumberLabel.text=subModel.COUNT;
        button.bottomShowLabel.text=subModel.NAME;
        
        if ([titleStr isEqualToString:@"今日待办任务"]) {
            button.topNumberLabel.textColor=DBColor(107, 243, 205);
        }else if ([titleStr isEqualToString:@"后三天待办任务"]){
            button.topNumberLabel.textColor=DBColor(253,186,80);
        }else{
            button.topNumberLabel.textColor=DBColor(253, 136, 150);
        }

        
        if ([subModel.COUNT isEqualToString:@"0"]) {
            button.topNumberLabel.text=@"✓";
            button.topNumberLabel.textColor=[UIColor greenColor];
        }
        
      
       
        
    }

    
}


#pragma mark  --
-(void)clickDefineButton:(newPHDefinedButton*)button{
    NSInteger number=button.tag-1000;
    NSArray*allArray=self.mainModel.content;
    
    subDicNextCountModel*subModel=allArray[number];
    NSString*typeName=self.mainModel.TYPE;
    
    if (self.clickButtonBlock) {
        self.clickButtonBlock(subModel, typeName);
    }
    
}


@end
