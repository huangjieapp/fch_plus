//
//  MJKAttachmentViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/17.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKAttachmentViewController.h"
#import "MJKMaterialPhotoView.h"
#import "CGCOrderDetailModel.h"

@interface MJKAttachmentViewController ()
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *urlArray;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *urlLoadArray;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation MJKAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DBSelf(weakSelf);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加附件";
    [self.urlLoadArray addObjectsFromArray:self.detailModel.urlList];
    MJKMaterialPhotoView *photoView = [[MJKMaterialPhotoView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - SafeAreaTopHeight - 54)];
    photoView.rootVC = self;
    photoView.vcName = @"订单附件";
    photoView.backUrlDataBlock = ^(NSData * _Nonnull data) {
        [weakSelf uppicAction:data];
       
    };
    photoView.backDelDataBlock = ^(NSInteger delTag) {
        [weakSelf.urlLoadArray removeObjectAtIndex:delTag];
    };
    
    [self.view addSubview:photoView];
    
    [self.view addSubview:self.commitButton];

}

-(void)uppicAction:(NSData *)data{
    
    DBSelf(weakSelf);
    
    //    NSData *data=[NSData dataWithContentsOfFile:self.patchUrl];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            NSString * imgUrl = [data objectForKey:@"url"];//回传
            //            [self setPicBtn:imgUrl];
            [weakSelf.urlLoadArray addObject:imgUrl];
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

- (void)httpUploadImage:(NSArray *)urlArr{
    DBSelf(weakSelf);
    NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:@"A42000WebService-upload"];
    
    NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
    dic1[@"C_ID"] = self.detailModel.C_ID;
    dic1[@"urlList"] = urlArr;
    [dic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
}

- (void)commitButtonAction {
    [self httpUploadImage:self.urlLoadArray];
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [[UIButton alloc]initWithFrame:CGRectMake(10, KScreenHeight - 49, KScreenWidth - 20, 44)];
        [_commitButton setTitleNormal:@"提交"];
        [_commitButton setTitleColor:[UIColor blackColor]];
        [_commitButton setBackgroundColor:KNaviColor];
        [_commitButton addTarget:self action:@selector(commitButtonAction)];
    }
    return _commitButton;
}

- (NSMutableArray *)urlArray {
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (NSMutableArray *)urlLoadArray {
    if (!_urlLoadArray) {
        _urlLoadArray = [NSMutableArray array];
    }
    return _urlLoadArray;
}

@end
