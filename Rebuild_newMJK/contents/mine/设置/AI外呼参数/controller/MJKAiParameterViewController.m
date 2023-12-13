//
//  MJKAiParameterViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKAiParameterViewController.h"

#import "MJKAiParameterCell.h"


@interface MJKAiParameterViewController ()<UITableViewDelegate, UITableViewDataSource>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** list data Array*/
@property (nonatomic, strong) NSMutableArray *listDataArray;
@end

@implementation MJKAiParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"AI外呼参数";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self httpPostAI];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.listDataArray[indexPath.row];
    MJKAiParameterCell *cell = [MJKAiParameterCell cellWithTableView:tableView];
    cell.titleLabel.text = dic[@"title"];
    if ([dic[@"content"] isKindOfClass:[NSNumber class]]) {
        cell.contentTF.text =  [NSString stringWithFormat:@"%@",dic[@"content"]];
    } else {
        cell.contentTF.text = dic[@"content"];
    }
    cell.contentTF.enabled = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)httpPostAI {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A65200WebService-getBeanByIdByAIWH"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            for (int i = 0; i < weakSelf.listDataArray.count; i++) {
                NSMutableDictionary *dic = weakSelf.listDataArray[i];
                if ([dic[@"C_TITlE"] isEqualToString:@"外呼主题编号"]) {
                    dic[@"content"] = data[@"C_ENGLISHNAME"];
                } else if ([dic[@"C_TITlE"] isEqualToString:@"机器人编号"]) {
                    dic[@"content"] = data[@"C_NUMBER"];
                } else if ([dic[@"C_TITlE"] isEqualToString:@"机器人数量"]) {
                    dic[@"content"] = data[@"I_TYPE"];
                } else if ([dic[@"C_TITlE"] isEqualToString:@"手机号码"]) {
                    dic[@"content"] = data[@"X_REMARK"];
                } else if ([dic[@"C_TITlE"] isEqualToString:@"序号"]) {
                    dic[@"content"] = data[@"C_CHANNEL_NUMBER"];
                }
            }
            [weakSelf.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        
    }
    return _tableView;
}

- (NSMutableArray *)listDataArray {
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray arrayWithObjects:
                          [@{@"C_TITlE" : @"外呼主题编号", @"title" : @"外呼主题编号"} mutableCopy],
                          [@{@"C_TITlE" : @"机器人编号", @"title" : @"机 器 人 编 号"} mutableCopy],
                          [@{@"C_TITlE" : @"机器人数量", @"title" : @"机 器 人 数 量"} mutableCopy],
                          [@{@"C_TITlE" : @"手机号码", @"title" : @"手  机    号  码"} mutableCopy],
                          [@{@"C_TITlE" : @"序号", @"title" : @"序               号"} mutableCopy], nil];
        
    }
    return _listDataArray;
}

@end
