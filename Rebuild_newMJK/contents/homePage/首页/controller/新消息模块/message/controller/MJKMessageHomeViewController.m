//
//  MJKMessageHomeViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/18.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKMessageHomeViewController.h"
#import "MJKMessageCenterViewController.h"

#import "MJKMessageHomeCollectionViewCell.h"

#import "MJKMessageHomeModel.h"

@interface MJKMessageHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic, assign) NSInteger tab;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation MJKMessageHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getMessageList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tab = 0;
    UIView *topView = [UIView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(25);
    }];
    topView.backgroundColor = [UIColor colorWithHex:@"#fff"];
    
    NSArray *titleArray = @[@"未读",@"已读"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton new];
        [topView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(topView);
            make.left.mas_equalTo(i * (KScreenWidth / 2));
            make.width.mas_equalTo(KScreenWidth / 2);
        }];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHex:@"#aaaaaa"]];
        if (i == 0) {
            UIView *sepView = [UIView new];
            [topView addSubview:sepView];
            
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(topView);
                make.right.equalTo(button.mas_right);
                make.width.mas_equalTo(1);
                
            }];
            sepView.backgroundColor = [UIColor colorWithHex:@"#efeff4"];
        }
        if (i == self.tab) {
            [button setBackgroundColor:KNaviColor];
        }
        button.tag = 100 + i;
        [self.buttonArray addObject:button];
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self);
            UIButton *button = self.buttonArray[self.tab];
            [button setBackgroundColor:[UIColor colorWithHex:@"#aaaaaa"]];
            self.tab = x.tag - 100;
            [x setBackgroundColor:KNaviColor];
            [self getMessageList];
        }];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 1;
    // 2.设置行间距
    layout.minimumLineSpacing = 1;
    layout.itemSize = CGSizeMake((KScreenWidth - 2) / 3, (KScreenWidth - 2) / 3 - 30);
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-AdaptSafeBottomHeight);
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor colorWithHex:@"#efeff4"];
    [_collectionView registerClass:[MJKMessageHomeCollectionViewCell class] forCellWithReuseIdentifier:@"MJKMessageHomeCollectionViewCell"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MJKMessageHomeModel *model = self.dataArray[indexPath.row];
    MJKMessageHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJKMessageHomeCollectionViewCell" forIndexPath:indexPath];
    cell.countLabel.text = model.COUNT;
    cell.titleLabel.text = model.C_TYPE_DD_NAME;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MJKMessageHomeModel *model = self.dataArray[indexPath.row];
    MJKMessageCenterViewController *vc = [MJKMessageCenterViewController new];
    vc.C_TYPE_DD_ID = model.C_TYPE_DD_ID;
    if (self.tab == 0) {
        vc.C_STATE_DD_ID = @"A61700_C_STATE_0001";
    } else {
        vc.C_STATE_DD_ID = @"A61700_C_STATE_0000";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getMessageList {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.tab == 0) {
        contentDic[@"C_STATE_DD_ID"] = @"A61700_C_STATE_0001";
    } else {
        contentDic[@"C_STATE_DD_ID"] = @"A61700_C_STATE_0000";
    }
    HttpManager *manager = [[HttpManager alloc]init];
    [manager  postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/a617/countRecord", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        MyLog(@"%@", data);
        self.dataArray = [MJKMessageHomeModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
        [self.collectionView reloadData];
    }];
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end
