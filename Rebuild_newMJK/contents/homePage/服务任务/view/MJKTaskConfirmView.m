//
//  MJKTaskConfirmView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/9.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTaskConfirmView.h"

#import "DBPickerView.h"

@interface MJKTaskConfirmView ()
@property (weak, nonatomic) IBOutlet UITextField *expectStartTF;
@property (weak, nonatomic) IBOutlet UITextField *expectFinishTF;
@property (weak, nonatomic) IBOutlet UITextField *levelTF;
/** 数据dic*/
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation MJKTaskConfirmView
- (void)awakeFromNib {
	[super awakeFromNib];
	
}



- (IBAction)closeView:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)timeTFAction:(UITextField *)sender {
	DBSelf(weakSelf);
	DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeDate andmtArrayDatas:nil  andSelectStr:nil andTitleStr:sender.tag == 100 ? @"预计开始时间" : @"预计完成时间" andBlock:^(NSString *title, NSString *indexStr) {
		MyLog(@"%@    %@",title,indexStr);
		if (sender.tag == 100) {
			weakSelf.expectStartTF.text = [title stringByAppendingString:@">"];
			weakSelf.dict[@"startTime"] = title;
		} else {
			weakSelf.expectFinishTF.text = [title stringByAppendingString:@">"];
			weakSelf.dict[@"finishTime"] = title;
		}
		
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
}

- (IBAction)submitAction:(UIButton *)sender {
	if (self.expectStartTF.text.length <= 0) {
		[JRToast showWithText:@"请选择预计开始时间"];
		return;
	}
	if (self.expectFinishTF.text.length <= 0) {
		[JRToast showWithText:@"请选择预计完成时间"];
		return;
	}
	if (self.levelTF.text.length <= 0) {
		[JRToast showWithText:@"请选择优先等级"];
		return;
	}
	if (self.chooseBlock) {
		self.chooseBlock(self.dict);
	}
	[self removeFromSuperview];
}

- (IBAction)levelTFAction:(id)sender {
	DBSelf(weakSelf);
	NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TASKSTATUS"];
	NSMutableArray*mtArray=[NSMutableArray array];
	
	NSMutableArray*postArray=[NSMutableArray array];
	for (MJKDataDicModel*model in dataArray) {
		[mtArray addObject:model.C_NAME];
		[postArray addObject:model.C_VOUCHERID];
	}
	DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray  andSelectStr:nil andTitleStr:@"优先等级" andBlock:^(NSString *title, NSString *indexStr) {
		MyLog(@"%@    %@",title,indexStr);
		weakSelf.levelTF.text = title;
		NSInteger number=[indexStr integerValue];
		NSString *postStr = postArray[number];
		weakSelf.dict[@"level"] = postStr;
		
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:pickerV];
}

- (NSMutableDictionary *)dict {
	if (!_dict) {
		_dict = [NSMutableDictionary dictionary];
	}
	return _dict;
}


@end
