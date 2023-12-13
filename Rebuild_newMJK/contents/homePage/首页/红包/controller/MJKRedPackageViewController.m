//
//  MJKRedPackageViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/30.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKRedPackageViewController.h"
#import "MJKOpenRedPackageModel.h"

@interface MJKRedPackageViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** stateView*/
@property (nonatomic, strong) UIView *stateView;
/** MJKOpenRedPackageModel*/
@property (nonatomic, strong) MJKOpenRedPackageModel *model;
/** <#注释#>*/
@property (nonatomic, strong) NSString *codeStr;
@end

@implementation MJKRedPackageViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    UIView* stateView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, KScreenWidth, 20)];
    self.stateView = stateView;
    [self.navigationController.navigationBar addSubview:stateView];
    stateView.backgroundColor = [UIColor colorWithHex:@"#FF5445"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:@"#FF5445"];
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.stateView removeFromSuperview];
    self.navigationController.navigationBar.barTintColor = KNaviColor;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self getRedPackageData];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UIImage *image = [UIImage imageNamed:@"奖惩"];
    return image.size.height + 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImage *image = [UIImage imageNamed:@"奖惩"];
    UIView *bgFView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, image.size.height + 50)];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, image.size.height)];
    [bgFView addSubview:bgView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:bgView.frame];
    imageView.image = image;
    [bgView addSubview:imageView];
    
    CGFloat titleHeight = [(self.model.C_VOUCHERNAME) boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.f]} context:nil].size.height;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, KScreenWidth - 20, titleHeight)];
    
    titleLabel.text = self.model.C_VOUCHERNAME;
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.textColor = [UIColor colorWithHex:@"#E3C999"];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame) + 10, KScreenWidth - 20, 20)];
    subTitleLabel.font = [UIFont systemFontOfSize:16.f];
    subTitleLabel.textColor = [UIColor colorWithHex:@"#E3C999"];
    if (self.codeStr.integerValue == 200) {
        subTitleLabel.text = @"您获得了一笔奖励,请继续加油哦";
    } else if (self.codeStr.integerValue == 201) {
    } else if (self.codeStr.integerValue == 202) {
    } else {
        subTitleLabel.text = @"您的红包已过期!";
    }
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:subTitleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(subTitleLabel.frame) + 20, KScreenWidth - 20, 30)];
    moneyLabel.font = [UIFont systemFontOfSize:18.f];
    moneyLabel.textColor = [UIColor colorWithHex:@"#E3C999"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",self.model.B_AMOUNT]];
    [str addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(self.model.B_AMOUNT.length, 1)];
    moneyLabel.attributedText = str;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    if (self.codeStr.integerValue == 200) {
        [bgView addSubview:moneyLabel];
    }
    
    UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(moneyLabel.frame) + 10, KScreenWidth - 20, 20)];
    noticeLabel.font = [UIFont systemFontOfSize:12.f];
    noticeLabel.textColor = [UIColor colorWithHex:@"#E3C999"];
    if (self.codeStr.integerValue == 200) {
        noticeLabel.text = @"已存入微信零钱,可直接转账 >";
    } else if (self.codeStr.integerValue == 201) {
    } else if (self.codeStr.integerValue == 202) {
    } else {
        noticeLabel.text = @"红包有效期为24小时!请及时领取!";
    }
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:noticeLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), KScreenWidth, 50)];
    contentLabel.font = [UIFont systemFontOfSize:16.f];
    contentLabel.textColor = [UIColor colorWithHex:@"#E3C999"];
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"MATCH智慧门店\n祝您工作顺利!多签单!签大单!";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [bgFView addSubview:contentLabel];
    
    return bgFView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)getRedPackageData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A71100WebService-open"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        [weakSelf.codeStr isEqualToString:data[@"code"]];
        if ([data[@"code"] integerValue]==200) {
            weakSelf.model = [MJKOpenRedPackageModel mj_objectWithKeyValues:data];
            [weakSelf.tableView reloadData];
        } else if ([data[@"code"] integerValue]==201) {//已领取
            
        } else if ([data[@"code"] integerValue]==202) {//未关注公众号
            
        } else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
