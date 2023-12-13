//
//  MJKPersonAttendanceViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPersonAttendanceViewController.h"

#import "CalendarView.h"

#import "MJKVacationModel.h"
#import "MJKMJKAttendanceDetailModel.h"


@interface MJKPersonAttendanceViewController ()<CalendarViewDelegate, UITableViewDataSource, UITableViewDelegate>
/** CalendarView*/
@property (nonatomic, strong) CalendarView *calendar;
/** 头 试图*/
@property (nonatomic, strong) UIView *titleView;
/** <#备注#>*/
@property (nonatomic, strong) NSString *slidTimeStr;
/** 个人考勤 model*/
@property (nonatomic, strong) MJKMJKAttendanceDetailModel *detailModel;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MJKPersonAttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	[self initUI];
}

- (void)initUI {
	DBSelf(weakSelf);
	self.title = @"个人考勤详情";
	[self httpDetailVacationSuccess:^(MJKVacationModel *model) {
		[weakSelf configPersonInfoView:model];
	}];
	
}

- (void)configPersonInfoView:(MJKVacationModel *)model {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 80)];
	self.titleView = bgView;
	bgView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:bgView];
	//个人照片
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
	[bgView addSubview:imageView];
	imageView.layer.cornerRadius = 25.f;
	imageView.layer.masksToBounds = YES;
	[imageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"logo-图标"]];
	
	//名字
	UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMinY(imageView.frame), KScreenWidth - 80, 20)];
	[bgView addSubview:nameLabel];
	nameLabel.textColor = [UIColor blackColor];
	nameLabel.font = [UIFont systemFontOfSize:14.f];
	nameLabel.text = model.C_NAME;
	
	//地址
	UILabel *addressLabel = [[UILabel alloc]init];
	[bgView addSubview:addressLabel];
	addressLabel.text = model.C_ADDRESS;
	addressLabel.numberOfLines = 0;
	addressLabel.textColor = [UIColor darkGrayColor];
	addressLabel.font = [UIFont systemFontOfSize:14.f];
	CGSize size = [addressLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : addressLabel.font} context:nil].size;
	addressLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 10, CGRectGetMaxY(nameLabel.frame) + 5, KScreenWidth - 80, size.height);
	
	
	[self.view addSubview:self.calendar];
	self.calendar.selecTime = self.timeStr;
	self.calendar.vacationModel = model;
	
	
	
	//下方标识
	for (int i=0; i<5; i++) {
		UIView *logoView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth / 5) * i + 10, CGRectGetMaxY(self.calendar.frame), (KScreenWidth-10) / 5, 50)];
		logoView.backgroundColor = [UIColor whiteColor];
		[self.view addSubview:logoView];
		
		UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(5, (logoView.frame.size.height - 10) / 2, 10, 10)];
		colorView.layer.cornerRadius = 5.f;
		colorView.layer.masksToBounds = YES;
		colorView.backgroundColor = @[KGreenColor, KBlueColor, KYellowColor, KRedColor, KPurpleColor][i];
		[logoView addSubview:colorView];
		
		UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(colorView.frame) + 5, 0, logoView.frame.size.width - colorView.frame.origin.x - colorView.frame.size.width - 5, logoView.frame.size.height)];
		titleLabel.text = @[@"正常出勤",@"迟到	/早退",@"忘签到/退",@"缺勤",@"休假"][i];
		titleLabel.font = [UIFont systemFontOfSize:10];
		titleLabel.textColor = [UIColor blackColor];
		[logoView addSubview:titleLabel];
		
	}
	
	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendar.frame)+50, KScreenWidth, 1)];
	sepView.backgroundColor = kBackgroundColor;
	
	
	[self.view addSubview:self.tableView];
	[self.view addSubview:sepView];
	[self httpAttendanceDetail];
}

//MARK: CalendarViewDelegate
-(void)slidingCalendar:(NSString *)date  andDirection:(UISwipeGestureRecognizerDirection)direction {
	self.timeStr = date;
	self.slidTimeStr = date;
	DBSelf(weakSelf);
	[self httpDetailVacationSuccess:^(MJKVacationModel *model) {
		weakSelf.calendar.vacationModel = model;
		[weakSelf httpAttendanceDetail];
	}];
}

- (void)calendarDidDateSelectedDate:(NSString *)date {
	self.timeStr = date;
	self.slidTimeStr = date;
	[self httpAttendanceDetail];
}

//MARK: UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.font = cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
	cell.textLabel.text = @[@"签到时间:",@"签退时间:"][indexPath.row];
	if (indexPath.row == 0) {
		cell.detailTextLabel.text = self.detailModel.D_TOWORK_TIME;
	} else {
		cell.detailTextLabel.text = self.detailModel.D_OFFWORK_TIME;
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1;
}

//MARK: 休假详情
- (void)httpDetailVacationSuccess:(void(^)(MJKVacationModel *model))completeBlock{
	self.slidTimeStr = self.timeStr;//默认
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A48800WebService-monthDetail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.timeStr.length > 0) {
		contentDict[@"DATE"] = [self.timeStr substringToIndex:7];;
	}
	contentDict[@"C_U03100_C_ID"] = self.listModel.C_U03100_C_ID;
	contentDict[@"TYPE"] = @"0";
//	contentDict[@"C_STATUS_DD_ID"] = @"A48800_C_STATUS_0005";
	
	
	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			MJKVacationModel *model = [MJKVacationModel mj_objectWithKeyValues:data];
			model.timeStr = weakSelf.slidTimeStr;
			if (completeBlock) {
				completeBlock(model);
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

//MARK: 个人当天考勤情况
- (void)httpAttendanceDetail {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A64600WebService-detail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	contentDict[@"DATE"] = [self.timeStr substringToIndex:10];
	contentDict[@"C_U03100_C_ID"] = self.listModel.C_U03100_C_ID;
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel = [MJKMJKAttendanceDetailModel mj_objectWithKeyValues:data];
			[weakSelf.tableView reloadData];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (CalendarView *)calendar {
	if (!_calendar) {
		_calendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), KScreenWidth, 220) andIsNoSel:@"NO"];
		_calendar.delegate = self;
		_calendar.noScroll = YES;
	}
	return _calendar;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendar.frame) + 50, KScreenWidth, KScreenHeight - self.calendar.frame.origin.y - self.calendar.frame.size.height - 50 - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
		_tableView.separatorColor = kBackgroundColor;
		_tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
	}
	return _tableView;
}

@end
