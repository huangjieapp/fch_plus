//
//  CreatDealSection1TableViewCell.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/12.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CreatDealSection1TableViewCell.h"

@implementation CreatDealSection1TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        
    }
    return self;
}

#pragma mark  --UI
-(void)setUpUI{
    UIView*topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    self.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:topView];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 12, KScreenWidth/2-15, 20)];
    titleLabel.font=[UIFont systemFontOfSize:17];
    titleLabel.text=@"服务内容";
    [topView addSubview:titleLabel];
    UIButton*inputButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2, 12, KScreenWidth/2-15, 20)];
    [inputButton setTitle:@"请输入"];
    inputButton.titleLabel.font=[UIFont systemFontOfSize:14];
    inputButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [inputButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [inputButton addTarget:self action:@selector(clickInput)];
    [topView addSubview:inputButton];
    
    //从44开始
   NSArray* array=@[@"洗车",@"全车打蜡镀膜",@"全车内饰清洁",@"更换空调滤芯",@"更换防冻液",@"更换轮胎",@"车漆修复",@"更换雨刮",@"小保养",@"大保养",@"换机油机滤三滤补胎维修清洗"];

    
    NSInteger Firstleft=15;
    NSInteger FirstTop=44;
    NSInteger maxWith=KScreenWidth-15-15;
    NSInteger TopBottomSpace=25+10;

    for (int i=0; i<array.count; i++) {
        
        
        UIButton*button=[[UIButton alloc]init];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        button.layer.borderWidth=1;
        button.layer.borderColor=[UIColor grayColor].CGColor;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag=1000+i;
        [button addTarget:self action:@selector(clickServiceType:)];
        [self.contentView addSubview:button];
        

        
      CGSize currentSize= [button.titleLabel.text boundingRectWithSize:CGSizeMake(maxWith, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
 
        if (Firstleft+currentSize.width+10>maxWith) {
            FirstTop=FirstTop+TopBottomSpace;
            Firstleft=15;
        }
     
        button.frame=CGRectMake(Firstleft, FirstTop, currentSize.width, 25);
        
        
    //赋值给下面的用
//            if (Firstleft+currentSize.width+10>maxWith) {
//                Firstleft=15;
//                FirstTop=FirstTop+TopBottomSpace;
//            }else{
//                Firstleft=Firstleft+currentSize.width+10;
//            }
        
        

          Firstleft=Firstleft+currentSize.width+10;
        
        
        
    
    }
    
    
}


+(CGFloat)calculatorHeightWithArray:(NSArray*)array{
    array=@[@"洗车",@"全车打蜡镀膜",@"全车内饰清洁",@"更换空调滤芯",@"更换防冻液",@"更换轮胎",@"车漆修复",@"更换雨刮",@"小保养",@"大保养",@"换机油机滤三滤补胎维修清洗"];
    NSInteger Firstleft=15;
    NSInteger FirstTop=44;
    NSInteger maxWith=KScreenWidth-15-15;
    NSInteger TopBottomSpace=25+10;

    for (int i=0; i<array.count; i++) {
        CGSize currentSize= [array[i] boundingRectWithSize:CGSizeMake(maxWith, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        if (Firstleft+currentSize.width+10>maxWith) {
            FirstTop=FirstTop+TopBottomSpace;
            Firstleft=15;
        }

        
          Firstleft=Firstleft+currentSize.width+10;
        
    }
    
    
    return FirstTop+TopBottomSpace;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}



#pragma mark  --touch
-(void)clickInput{
    MyLog(@"11");
    
}

-(void)clickServiceType:(UIButton*)sender{
    NSInteger number=sender.tag-1000;
   NSArray* array=@[@"洗车",@"全车打蜡镀膜",@"全车内饰清洁",@"更换空调滤芯",@"更换防冻液",@"更换轮胎",@"车漆修复",@"更换雨刮",@"小保养",@"大保养",@"换机油机滤三滤补胎维修清洗"];
    MyLog(@"%@",array[number]);
    
    
}


@end
