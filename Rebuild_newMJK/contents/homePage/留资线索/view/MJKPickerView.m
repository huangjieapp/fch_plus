//
//  MJKPickerView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKPickerView.h"

@interface MJKPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation MJKPickerView
- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self createPickerView:frame];
	}
	return self;
}

- (void)setArr:(NSArray<MJKDataDicModel *> *)arr {
	_arr = arr;
	[self.pickerView reloadAllComponents];
}

- (void)createPickerView:(CGRect )frame {
	UIView *backgroundView = [[UIView alloc]initWithFrame:frame];
	backgroundView.backgroundColor = [UIColor blackColor];
	backgroundView.alpha = 0.5;
	[self addSubview:backgroundView];
	
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePickerView:)];
	[backgroundView addGestureRecognizer:tapGR];
	
	UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 200, KScreenWidth, 200)];
	self.pickerView = pickerView;
	pickerView.backgroundColor = [UIColor whiteColor];
	pickerView.dataSource = self;
	pickerView.delegate = self;
	[self addSubview:pickerView];
	
	UIView *cancelView = [[UIView alloc]initWithFrame:CGRectMake(0 , frame.size.height - pickerView.frame.size.height - 20, frame.size.width, 20)];
	cancelView.backgroundColor = [UIColor whiteColor];
	[self addSubview:cancelView];
	
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	closeButton.frame = CGRectMake(0, 10, 60, 10);
	[closeButton setTitle:@"取消" forState:UIControlStateNormal];
	closeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
	[cancelView addSubview:closeButton];
	
	UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
	yesButton.frame = CGRectMake(cancelView.frame.size.width - 60, 10, 60, 10);
	[yesButton setTitle:@"确定" forState:UIControlStateNormal];
	yesButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[yesButton addTarget:self action:@selector(yesButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[cancelView addSubview:yesButton];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.arr.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return self.arr[row].C_NAME;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.row = row;
}
#pragma mark - 关闭Picker
- (void)closePickerView:(UIGestureRecognizer *)sender {
	self.hidden = YES;
}

- (void)yesButtonAction:(UIButton *)sender {
#warning 哪里用到 哪里倒霉    C_VOUCHERID
    if (self.arr.count<1) {
        self.hidden=YES;
        return;
    }
    
    //市场活动取C_ID   别的地方取 C_VOUCHERID
    if (_indexRow==3) {
        if (self.selectBlock) {
            self.selectBlock(self.arr[_row].C_NAME, self.arr[_row].C_ID,self.arr[_row].C_VOUCHERID);
        }
    }else{
        if (self.selectBlock) {
            self.selectBlock(self.arr[_row].C_NAME, self.arr[_row].C_VOUCHERID,self.arr[_row].C_ID);
        }
    }
    
    
    
//    if (self.selectBlock) {
//        self.selectBlock(self.arr[_row].C_NAME,self.indexRow == 3 ? self.arr[_row].C_VOUCHERID : self.arr[_row].C_VOUCHERID);
//    }
	self.hidden = YES;
}

- (void)closeView:(UIButton *)sender {
	self.hidden = YES;
}

- (void)dealloc {
	
}
@end
