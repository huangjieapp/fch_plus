//
//  CustomerDetailFirstRowTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/22.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CustomerDetailFirstRowTableViewCell.h"
#import "CustomerDetailChooseView.h"


@interface CustomerDetailFirstRowTableViewCell()
@property (weak, nonatomic) IBOutlet UITextView *topRemarkTextView;
@property(nonatomic,strong)NSMutableArray*saveAllButtonViewArray;  //报错所有的 选择按钮
/** 点击的那个button*/
@property (nonatomic, assign) NSInteger buttonTag;

@property (nonatomic, strong) UIView *bottonView;
@end

@implementation CustomerDetailFirstRowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   //60 地方开始 总高110    总高140
    
    UIView*bottomMainView=[[UIView alloc]initWithFrame:CGRectMake(0, 60+30+40, KScreenWidth, 45)];
    [self addSubview:bottomMainView];
    
//    NSArray*localName=@[@"全部",@"线索",@"来电",@"流量",@"预约",@"跟进", @"任务",@"订单"];
//    NSArray*localNumber=@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    NSArray*localName=@[@"轨迹",@"流量信息",@"跟进信息",@"订单信息",@"电话录音"];
    NSArray*localNumber=@[@"0",@"0",@"0",@"0",@"0"];
    CGFloat buttonViewWith=(KScreenWidth-(localName.count-1)*1)/localName.count;
    CGFloat buttonViewHeight=bottomMainView.height;
    CGFloat firstLeft=0;
    for (int i=0; i<localName.count; i++) {
        CustomerDetailChooseView*viewButton=[[CustomerDetailChooseView alloc]initWithFrame:CGRectMake(firstLeft, 0, buttonViewWith, buttonViewHeight)];
        viewButton.titleStr=localName[i];
        viewButton.numberStr=localNumber[i];
        
        
        viewButton.tag=1000+i;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTapView:)];
        [viewButton addGestureRecognizer:tap];
        [bottomMainView addSubview:viewButton];
        
        if (i!=localName.count-1) {
            UIView*VerLineView=[[UIView alloc]initWithFrame:CGRectMake(firstLeft+buttonViewWith, 0, 1, buttonViewHeight)];
            VerLineView.backgroundColor=DBColor(194, 194, 194);
            [bottomMainView addSubview:VerLineView];
         
        }
        
        firstLeft=firstLeft+buttonViewWith+1;
        
        
        [self.saveAllButtonViewArray addObject:viewButton];
        
    }
    self.bottonView=bottomMainView;
    
    //默认
    CustomerDetailChooseView*viewButton=self.saveAllButtonViewArray[0];
    viewButton.bottomLabel.backgroundColor=KNaviColor;
    viewButton.topLabel.textColor=DBColor(115, 115, 115);
    
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(NSString *)strType{
	static NSString *ID = @"CustomerDetailFirstRowTableViewCell";
	CustomerDetailFirstRowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		
	}
	return cell;
	
}


#pragma mark  --click
- (IBAction)clickPhone:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(0);
    }
}
- (IBAction)clickInfo:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(1);
    }
}
- (IBAction)clickWechat:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(2);
    }
}


- (IBAction)clickEdit:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(3);
    }
}
- (IBAction)clickCard:(id)sender {
    if (self.clickTopThreeButtonBlock) {
        self.clickTopThreeButtonBlock(4);
    }
}

-(void)clickTapView:(UITapGestureRecognizer*)tap{
    CustomerDetailChooseView*viewButton=(CustomerDetailChooseView*)tap.view;
    if ([viewButton.bottomLabel.text isEqualToString:@"0"]) {
        return;
    }

    self.buttonTag = tap.view.tag;
    NSInteger tagNumber=tap.view.tag-1000;
    for (CustomerDetailChooseView*viewButton in self.saveAllButtonViewArray) {
        if (viewButton.tag==tap.view.tag) {
            viewButton.bottomLabel.backgroundColor=KNaviColor;
            viewButton.topLabel.textColor=DBColor(115, 115, 115);
            
        }else{
            viewButton.bottomLabel.backgroundColor=DBColor(219, 219, 219);
            viewButton.topLabel.textColor=DBColor(211, 211, 211);
        }
        
    }
    
    if (self.clickBottomEightButtonBlock) {
        self.clickBottomEightButtonBlock(tagNumber);
    }
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}


#pragma mark  --set
-(NSMutableArray *)saveAllButtonViewArray{
    if (!_saveAllButtonViewArray) {
        _saveAllButtonViewArray=[NSMutableArray array];
    }
    
    return _saveAllButtonViewArray;
}



-(void)setNumberArray:(NSMutableArray *)numberArray{
    _numberArray=numberArray;
	
    if (self.saveAllButtonViewArray.count==numberArray.count) {
        for (int i=0; i<self.saveAllButtonViewArray.count; i++) {
            CustomerDetailChooseView*viewButton=self.saveAllButtonViewArray[i];
            viewButton.bottomLabel.text=[numberArray[i] length] > 0 ? numberArray[i] : @"0";
			if (viewButton.tag == self.buttonTag) {
				viewButton.bottomLabel.backgroundColor=KNaviColor;
			} else {
				//默认
				if (self.buttonTag <= 0) {//未点击为默认
					CustomerDetailChooseView*viewButton=self.saveAllButtonViewArray[0];
					viewButton.bottomLabel.backgroundColor=KNaviColor;
					
				} else {
					viewButton.bottomLabel.backgroundColor=DBColor(219, 219, 219);
				}
				
			}
            //默认的
//            if (i==0) {
//                viewButton.bottomLabel.backgroundColor=KNaviColor;
//            }else{
//                viewButton.bottomLabel.backgroundColor=DBColor(219, 219, 219);
//            }
			
        }
        
        
    }
    
    
	

}


-(void)setRemarkText:(NSString *)remarkText{
    _remarkText=remarkText;
    self.topRemarkTextView.text=[NSString stringWithFormat:@"备注:%@",remarkText];
    
}

-(void)setType:(NSString *)type{
	
	_type=type;
    DBSelf(weakSelf);
	if ([_type isEqualToString:@"customer"]) {
		[self.bottonView removeFromSuperview];
		[self.saveAllButtonViewArray removeAllObjects];
		UIView*bottomMainView=[[UIView alloc]initWithFrame:CGRectMake(0, 60+30+40, KScreenWidth, 45)];
		[self addSubview:bottomMainView];
		self.bottonView=bottomMainView;
		
		NSArray*localName=@[@"订单",@"常规维护",@"拜访",@"转介绍"];
		NSArray*localNumber=@[@"0",@"0",@"7",@"0"];
		CGFloat buttonViewWith=(KScreenWidth-(localName.count-1)*1)/localName.count;
		CGFloat buttonViewHeight=self.bottonView.height;
		CGFloat firstLeft=0;
		for (int i=0; i<localName.count; i++) {
			CustomerDetailChooseView*viewButton=[[CustomerDetailChooseView alloc]initWithFrame:CGRectMake(firstLeft, 0, buttonViewWith, buttonViewHeight)];
			viewButton.titleStr=localName[i];
			viewButton.numberStr=localNumber[i];
			
			
			viewButton.tag=1000+i;
			UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTapView:)];
			[viewButton addGestureRecognizer:tap];
			[self.bottonView addSubview:viewButton];
			
			if (i!=localName.count-1) {
				UIView*VerLineView=[[UIView alloc]initWithFrame:CGRectMake(firstLeft+buttonViewWith, 0, 1, buttonViewHeight)];
				VerLineView.backgroundColor=DBColor(194, 194, 194);
				[self.bottonView addSubview:VerLineView];
				
			}
			
			firstLeft=firstLeft+buttonViewWith+1;
			
			
			[self.saveAllButtonViewArray addObject:viewButton];
			
		}
		
		
		//默认
		CustomerDetailChooseView*viewButton=self.saveAllButtonViewArray[0];
		viewButton.bottomLabel.backgroundColor=KNaviColor;
		viewButton.topLabel.textColor=DBColor(115, 115, 115);
    } else if ([_type isEqualToString:@"fans"]) {
        [self.bottonView removeFromSuperview];
        [self.saveAllButtonViewArray removeAllObjects];
        
        UIView*bottomMainView=[[UIView alloc]initWithFrame:CGRectMake(0, 60+30+40, KScreenWidth, 45)];
        [self addSubview:bottomMainView];
        
        NSArray*localNumber=@[@"订单",@"常规维护",@"拜访",@"售后",@"增值"];
        for (int i = 0; i < localNumber.count; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * ((KScreenWidth - 4) / localNumber.count + 1), 0, (KScreenWidth - 4) / localNumber.count, 20)];
            
            [button setTitle:localNumber[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bottomMainView addSubview:button];
            [button setBackgroundColor:[UIColor colorWithHex:@"#aaaaaa"]];
            button.tag = 10000+i;
            [self.saveAllButtonViewArray addObject:button];
            if (i == self.tag.intValue) {
                [button setBackgroundColor:KNaviColor];
            }
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                if (weakSelf.clickBottomEightButtonBlock) {
                    weakSelf.clickBottomEightButtonBlock(button.tag - 10000);
                }
                UIButton *tempButton = weakSelf.saveAllButtonViewArray[weakSelf.tag.intValue];
                [tempButton setBackgroundColor:[UIColor colorWithHex:@"#aaaaaa"]];
                [button setBackgroundColor:KNaviColor];
            }];
        }
        
//        UIView*bottomMainView=[[UIView alloc]initWithFrame:CGRectMake(0, 60+30+40, KScreenWidth, 45)];
//        [self addSubview:bottomMainView];
//        self.bottonView=bottomMainView;
//
//        NSArray*localName=@[@"",@"",@"",@"",@""];
//        NSArray*localNumber=@[@"订单",@"常规维护",@"拜访",@"售后",@"增值"];
//        CGFloat buttonViewWith=(KScreenWidth-(localName.count-1)*1)/localName.count;
//        CGFloat buttonViewHeight=self.bottonView.height;
//        CGFloat firstLeft=0;
//        for (int i=0; i<localName.count; i++) {
//            CustomerDetailChooseView*viewButton=[[CustomerDetailChooseView alloc]initWithFrame:CGRectMake(firstLeft, 0, buttonViewWith, buttonViewHeight)];
//            viewButton.titleStr=localName[i];
//            viewButton.numberStr=localNumber[i];
//
//
//            viewButton.tag=1000+i;
//            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTapView:)];
//            [viewButton addGestureRecognizer:tap];
//            [self.bottonView addSubview:viewButton];
//
//            if (i!=localName.count-1) {
//                UIView*VerLineView=[[UIView alloc]initWithFrame:CGRectMake(firstLeft+buttonViewWith, 0, 1, buttonViewHeight)];
//                VerLineView.backgroundColor=DBColor(194, 194, 194);
//                [self.bottonView addSubview:VerLineView];
//
//            }
//
//            firstLeft=firstLeft+buttonViewWith+1;
//
//
//            [self.saveAllButtonViewArray addObject:viewButton];
//
//        }
        
        
        //默认
//        CustomerDetailChooseView*viewButton=self.saveAllButtonViewArray[0];
//        viewButton.bottomLabel.backgroundColor=KNaviColor;
//        viewButton.topLabel.textColor=DBColor(115, 115, 115);
    }
	
	
	
}


@end
