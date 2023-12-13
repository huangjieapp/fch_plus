//
//  CGCExpandVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCExpandVC.h"
#import "CGCExpandModel.h"

#import <Masonry/Masonry.h>
//#import <SJRouter/SJRouter.h>
#import "SJTableViewCell.h"
#import "SJVideoPlayer.h"
#import "ExpandCell.h"
#import "MJKWorkWorldListCell.h"

#import "MJKWorkWorldListModel.h"

#import "ZZBigView.h"
#import "CLPlayerView.h"
#import "WXApi.h"

#import "ZZShareView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "KSPhotoItem.h"
#import "MJKPhotoBrowser.h"

#import "MJKFlowInstrumentSubModel.h"
#import <AFNetworkActivityIndicatorManager.h>

#import "XMGTopicVideoView.h"
#import "XMGTopicPictureView.h"

#import "CGCNavSearchTextView.h"
#import "VoiceView.h"

#import "MJKCommunityScreenViewController.h"
#import "MJKExpandAddViewController.h"
#import "MJKExpandLabelViewController.h"

#import "MJKExpandDetailViewController.h"
#import "MJKExpandPictureViewController.h"

#import "MJKPlayVideoTableViewCell.h"

static NSString *kLinkURL = @"http://www.jianshu.com/u/c693e77d617c";
@interface CGCExpandVC ()<UITableViewDelegate,UITableViewDataSource,ZZShareDelegate>

//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) NSMutableArray *dataArray;

/** <#注释#>*/
@property (nonatomic, strong) VoiceView *vv;


@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) ZFPlayerView        *playerView;
//@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, assign) ExpandCell * cell;

/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;

@property (nonatomic, strong) ZZShareView *sharView;

@property (nonatomic, strong) CGCExpandModel  *exModel;

@property (strong, nonatomic) AVPlayerItem *playerItem;
/** deviceNo Array*/
@property (nonatomic, strong) NSMutableArray *deviceNOArray;

/** <#注释#>*/
@property (nonatomic, strong) NSString *searchStr;

/** <#注释#>*/
@property (nonatomic, strong) NSString *searchArea;
@property (nonatomic, strong) NSString *searchLabel;

/** <#注释#>*/
@property (nonatomic, strong) UIView *chooseView;

/** <#注释#>*/
@property (nonatomic, assign) NSInteger pagen;

@end


static AVPlayer * video_player_;
static AVPlayerLayer *playerLayer_;
static UIButton *lastPlayBtn_;
static CGCExpandModel *lastTopicM_;
static NSTimer *avTimer_;
static UIProgressView *progress_;


@implementation CGCExpandVC

// 页面消失时候
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
////    [self.playerView resetPlayer];
//    //videoView.img
//    _cell.videoView.img.hidden = NO;
//    [_playerView destroyPlayer];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title=@"推广素材";
    [self createNav];
    [self configRefresh];
//    [self httpRequestList];
	[self httpGetDeviceList];
//    [self.view addSubview:self.chooseView];
    [self.view addSubview:self.tableView];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf httpRequestList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf httpRequestList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)createNav{
    
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    
    self.navigationItem.title = @"素材推广";
    
    
    
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入素材描述" withRecord:^{//点击录音
        //        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
        //        [voiceVC setBackStrBlock:^(NSString *str){
        //            if (str.length>0) {
        //                _CurrentTitleView.textField.text = str;
        //                self.searchStr=str;
        //                [self.tableView.mj_header beginRefreshing];
        //            }
        //        }];
        self.vv = [[VoiceView alloc]initWithFrame:self.view.frame];
        
        [self.view addSubview:self.vv];
        //        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
        [weakSelf.vv start];
        weakSelf.vv.recordBlock = ^(NSString *str) {
            
            _CurrentTitleView.textField.text = str;
            self.searchStr=str;
            [self.tableView.mj_header beginRefreshing];
            
        };
        
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        if (str.length>0) {
            self.searchStr=str;
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.searchStr=@"";
            [self.tableView.mj_header beginRefreshing];
        }
    }];
    
    
//    self.navigationItem.titleView = self.CurrentTitleView;
    
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setTitleNormal:@"+"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [button addTarget:self action:@selector(addAction)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchButton setImage:@"搜索按钮"];
    [searchButton addTarget:self action:@selector(searchAction:)];
    searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:button], [[UIBarButtonItem alloc]initWithCustomView:searchButton]];
    
}

- (void)searchAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        [sender setImage:@"X图标"];
        self.navigationItem.titleView = self.CurrentTitleView;
    } else {
        [sender setImage:@"搜索按钮"];
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"素材推广";
        if (self.CurrentTitleView.textField.text.length > 0) {
            self.CurrentTitleView.textField.text = @"";
            self.searchStr = @"";
            [self.tableView.mj_header beginRefreshing];
        }
        
    }
}

- (void)httpPushInfo:(CGCExpandModel *)model {

	
//	NSString *urlString = HTTP_pushMaterial;
//
//	AFHTTPSessionManager *manger =[AFHTTPSessionManager manager];
//	manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/plain",nil];
////	[manger.requestSerializer setValue:@"text/html" forKey:@"Content-type"];
////	[manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//	[manger.requestSerializer setValue:[NewUserSession instance].accountId forHTTPHeaderField:@"accountId"];
//
//
//	[manger.requestSerializer setValue:[NewUserSession instance].C_LOCCODE forHTTPHeaderField:@"loccode"];
//
//
//	NSLog(@"%@-=-=%@",[NewUserSession instance].accountId,[NewUserSession instance].C_LOCCODE);
//
//	[manger.requestSerializer setValue:@"ios" forHTTPHeaderField:@"app"];
	NSMutableDictionary * dict=[NSMutableDictionary dictionary];
	[dict setObject:self.deviceNOArray forKey:@"deviceNo"];
	if (model.images.count > 0) {
		[dict setObject:model.images forKey:@"url"];
		[dict setObject:@"img" forKey:@"type"];
	}
	if (model.video.length > 0) {
		[dict setObject:@[model.video] forKey:@"url"];
		[dict setObject:@"video" forKey:@"type"];
	}
//
	
//	[manger POST:urlString parameters:dict progress:^(NSProgress * _NonnulluploadProgress){
//
//	}success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		NSLog(@"成功");
//
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//		NSLog(@"%@",error);
//		NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
//		NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//		NSLog(@"服务器的错误原因:%@",str);
//	}];
	
	NSURL *url = [NSURL URLWithString:HTTP_pushMaterial];;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	// 告诉服务器数据为json类型
//	if (model.images.count > 0) {
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NewUserSession instance].accountId forHTTPHeaderField:@"accountId"];


	[request setValue:[NewUserSession instance].user.C_LOCCODE forHTTPHeaderField:@"loccode"];


	NSLog(@"%@-=-=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.C_LOCCODE);

	[request setValue:@"ios" forHTTPHeaderField:@"app"];

	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
	request.HTTPBody = jsonData;

	NSURLSession *sharedSession = [NSURLSession sharedSession];
	NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		NSLog(@"%@",[NSThread currentThread]);
		if (data && (error == nil)) {
			// 网络访问成功
			NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
		} else {
			// 网络访问失败
			NSLog(@"error=%@",error);
		}
	}];
	[dataTask resume];
}

- (void)httpGetDeviceList {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getFlowSetList];
	[dict setObject:@{@"currPage" : @"1", @"pageSize" : @"1000", @"TYPE" : @"4", @"ISPAGE" : @"1"} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			NSArray *dataArray = [MJKFlowInstrumentSubModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			for (MJKFlowInstrumentSubModel *model in dataArray) {
				if ([model.ISCHECK isEqualToString:@"true"]) {
					[weakSelf.deviceNOArray addObject:model.C_NUMBER];
				}
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)httpRequestList{
    DBSelf(weakSelf);
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
//     [dict setObject:[NewUserSession instance].TOKEN forKey:@"usertoken"];
    [dict setObject:[NewUserSession instance].user.C_LOCCODE forKey:@"storeid"];
//    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    
    if (self.searchStr.length > 0) {
        //searchname
        [dict setObject:self.searchStr forKey:@"searchname"];
    } else {
        [dict setObject:@"" forKey:@"searchname"];
    }
    if (self.searchArea.length > 0) {
        //searchArea
        [dict setObject:self.searchArea forKey:@"searchaddress"];
    } else {
        [dict setObject:@"" forKey:@"searchaddress"];
    }
    if (self.searchLabel.length > 0) {
        //searchLabel
        [dict setObject:self.searchLabel forKey:@"searchlabel"];
    } else {
        [dict setObject:@"" forKey:@"searchlabel"];
    }
    
    dict[@"currPage"] = @"1";
    dict[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pagen];
//    [dict setObject:contentDict forKey:@"content"];
//    @"192.168.1.184:8081/api/material/home"
//    HTTP_materialList
    
    [[POPRequestManger defaultManger] requestWithNoHudMethod:POST url:[[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"] ? HTTP_materialList : HTTP_materialListTest dict:dict target:self andIsHud:NO finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            if (self.dataArray.count > 0) {
                [self.dataArray removeAllObjects];
            }
            for (NSMutableDictionary * dict in responsed[@"list"]) {
                CGCExpandModel * model=[CGCExpandModel yy_modelWithJSON:dict];
                [weakSelf.dataArray addObject:model];
            }
            
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        
    } failed:^(id error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    
}

- (void)httpShareWithSid:(NSString *)sid{
    
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NewUserSession instance].TOKEN forKey:@"usertoken"];
    [dict setObject:sid forKey:@"productid"];
    //    @"192.168.1.184:8081/api/material/home"
    //    HTTP_materialList
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_shareTJ dict:dict target:self finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            
           
            
        }
      
        
    } failed:^(id error) {
        
    }];
    
    
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
- (void)shareBtnClick:(UIButton *)btn{
    
  
        self.sharView = [[ZZShareView alloc]initWithdelegate:self];
        [self.view addSubview:self.sharView];
   
    self.exModel=self.dataArray[btn.tag];
    
}

/// 分享视图代理
- (void)selectBtn:(ZZShareView *)shareView withButtonTitle:(NSString *)buttonTitle{
    
    
    if ([buttonTitle isEqualToString:@"微信好友"]) {
  
//        [self sendWeiXin:@"hahah" withDesc:@"hahahh" withImg:self.exModel.poster];
        
        if ([self.exModel.type intValue]==0) {
         [self shareMinWXWith:self.exModel.sid withImgStr:[self.exModel.images firstObject]];
        }else{
             [self shareMinWXWith:self.exModel.sid withImgStr:self.exModel.poster];
        }
        [self httpShareWithSid:self.exModel.sid];
    }
    if ([buttonTitle isEqualToString:@"朋友圈"]) {
     
        if ([self.exModel.type intValue]==0||[self.exModel.type intValue]==3) {
             [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:[self.exModel.images firstObject]];
        }else{
            [self sendWeiXin:self.exModel.title withDesc:self.exModel.content withImg:self.exModel.poster];
        }
        
        [self httpShareWithSid:self.exModel.sid];
    }
    if ([buttonTitle isEqualToString:@"QQ好友"]) {
     
        [self sendWeiXin:@"hahah" withDesc:@"hahahh" withImg:self.exModel.poster];
    }
	if ([buttonTitle isEqualToString:@"投屏"]) {
		NSLog(@"投屏");
		[self httpPushInfo:self.exModel];
	}
    
}

#pragma mark - 搜索
- (void)searchViewButtonAction:(UIButton *)sender {
    DBSelf(weakSelf);
    if (sender.tag == 100) {//@"小区搜索"
        MJKCommunityScreenViewController *vc = [[MJKCommunityScreenViewController alloc]init];
        vc.sureBackBlock = ^(NSString * _Nonnull str, NSString * _Nonnull nameStr) {
            if (str.length > 0) {
                [sender setTitleNormal:nameStr];
            } else {
                [sender setTitleNormal:@"小区搜索"];
            }
            weakSelf.searchArea = str;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MJKExpandLabelViewController *vc = [[MJKExpandLabelViewController alloc]init];
        vc.selectLabelBackBlock = ^(NSString * _Nonnull idStr, NSString * _Nonnull nameStr) {
            if (nameStr.length > 0) {
                [sender setTitleNormal:nameStr];
            } else {
                [sender setTitleNormal:@"标签搜索"];
            }
            weakSelf.searchLabel = idStr;
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)httpGetAccountIdWithSuccessBlock:(void(^)(NSString *userToken, NSString *openId))completeBlock {
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setObject:[NewUserSession instance].user.u051Id forKey:@"userId"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:@"https://www.fchcrm.com/api/feedBroker/getAccountInfo" dict:dict target:self finished:^(id responsed) {
        
        if ([responsed[@"code"] intValue]==200) {
            MyLog(@"%@",responsed);
            if ([responsed[@"userToken"] length] > 0) {
                if (completeBlock) {
                    completeBlock(responsed[@"userToken"],responsed[@"openid"]);
                }
            } else {
                [self loginWX];
            }
            
            
        } else if (([responsed[@"code"] intValue]==400)) {
            [JRToast showWithText:@"账号尚未同步"];
        }
        
    } failed:^(id error) {
        
    }];
}

- (void)loginWX {
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
    launchMiniProgramReq.path = @"/pages/login/login";    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:nil];
}

#pragma mark - addAction
- (void)addAction {
    DBSelf(weakSelf);
    [self httpGetAccountIdWithSuccessBlock:^(NSString *userToken, NSString *openId) {
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
        launchMiniProgramReq.path = @"pages/materialAdd/materialAdd?show=1";    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypePreview; //拉起小程序的类型
        [WXApi sendReq:launchMiniProgramReq completion:nil];
    }];
//    MJKExpandAddViewController *vc = [[MJKExpandAddViewController alloc]init];
//
//    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction *sheetAction = [UIAlertAction actionWithTitle:@"图片素材" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        vc.A47800_C_TYPE = @"A47800_C_TYPE_0001";
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//
//    UIAlertAction *sheetAction1 = [UIAlertAction actionWithTitle:@"视频素材" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        vc.A47800_C_TYPE = @"A47800_C_TYPE_0002";
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//
//    UIAlertAction *sheetAction2 = [UIAlertAction actionWithTitle:@"链接素材" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        vc.A47800_C_TYPE = @"A47800_C_TYPE_0003";
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//    //A47800_C_TYPE_0005
//    UIAlertAction *sheetAction3 = [UIAlertAction actionWithTitle:@"图文素材" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        vc.A47800_C_TYPE = @"A47800_C_TYPE_0005";
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
//    UIAlertAction *sheetAction4 = [UIAlertAction actionWithTitle:@"公众号素材" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//           vc.A47800_C_TYPE = @"A47800_C_TYPE_0006";
//           [weakSelf.navigationController pushViewController:vc animated:YES];
//       }];
//    UIAlertAction *cancelSheetAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//
//    [alertV addAction:cancelSheetAction];
//
//    [alertV addAction:sheetAction];
//    [alertV addAction:sheetAction1];
//    [alertV addAction:sheetAction2];
//    [alertV addAction:sheetAction3];
//    [alertV addAction:sheetAction4];
//
//    [self presentViewController:alertV animated:YES completion:nil];
}

#pragma mark --- 微信分享
- (void)sendWeiXin:(NSString *)title withDesc:(NSString *)desc withImg:(NSString *)imgUrl{
    
   
    UIImage *image=[self handleImageWithURLStr:imgUrl];
    
  
    
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = title;//分享标题
    urlMessage.description = desc;//分享描述
    [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
  
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    if ([self.exModel.type intValue]==3) {
          webObj.webpageUrl = [NSString stringWithFormat:@"%@%@?a=%@",HTTP_sharePYQ,self.exModel.sid,self.exModel.accountid];
        
        NSLog(@"%@---",[NSString stringWithFormat:@"%@%@?a=%@",HTTP_sharePYQ,self.exModel.sid,self.exModel.accountid]);
    }else{
        webObj.webpageUrl = [NSString stringWithFormat:@"%@?accountId=%@&productId=%@",HTTP_shareSPZP,self.exModel.accountid,self.exModel.sid];
        
        
        NSLog(@"%@++++=====",[NSString stringWithFormat:@"%@?accountId=%@&productId=%@",HTTP_shareSPZP,self.exModel.accountid,self.exModel.sid]);
    }
  
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    
   
   
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = WXSceneTimeline;
    req.bText = NO;
    req.message = urlMessage;
    [WXApi sendReq:req completion:nil];
    
    
}


- (void)shareMinWXWith:(NSString *)sid withImgStr:(NSString *)imgStr{
    
      UIImage *image=[self handleImageWithURLStr:imgStr];
    
    WXMiniProgramObject *miniProgramObj = [WXMiniProgramObject object];
    miniProgramObj.webpageUrl = @"http://www.qq.com"; // 兼容低版本的网页链接
    miniProgramObj.miniProgramType=WXMiniProgramTypeRelease;
  
    miniProgramObj.userName = [NewUserSession instance].C_GID;     // 小程序原始id
    miniProgramObj.path = [NSString stringWithFormat:@"/pages/product/product?share=true&id=%@&shareopenid=%@",sid,[NewUserSession instance].user.C_OPENID];            //小程序页面路径
    miniProgramObj.hdImageData= UIImagePNGRepresentation(image);
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = @"脉居客";                    // 小程序消息title
    msg.description = @"脉居客";// 小程序消息desc
    msg.thumbData = UIImagePNGRepresentation(image);// 小程序消息封面图片，小于128k
    msg.mediaObject=miniProgramObj;
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
  
    req.message = msg;
    req.scene = WXSceneSession;  // 目前支持会话
    [WXApi sendReq:req completion:nil];
    
}


- (UIImage *)handleImageWithURLStr:(NSString *)imageURLStr {

    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
    NSData *newImageData = imageData;
    // 压缩图片data大小
    newImageData = UIImageJPEGRepresentation([UIImage imageWithData:newImageData scale:0.1], 0.1f);
    UIImage *image = [UIImage imageWithData:newImageData];

    // 压缩图片分辨率(因为data压缩到一定程度后，如果图片分辨率不缩小的话还是不行)
    CGSize newSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    MJKPlayVideoTableViewCell *cell = [MJKPlayVideoTableViewCell cellWithTableView:tableView];

//    CGCExpandModel * model=self.dataArray[indexPath.row];
//    cell.model = model;
//    ExpandCell * cell=[ExpandCell cellWithTableView:tableView];
//    CGCExpandModel * model=self.dataArray[indexPath.row];
//    cell.expand=model;
//    cell.picClick = ^(NSInteger index, NSString *imgStr) {
//        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:model.images with:index];
//
//        [bigView show];
//    };
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.shareBtn.tag=indexPath.row;
////    [cell.shareBtn addTarget:self action:@selector(shareBtnClick:)];
//    [cell.pictureView.moreButton addTarget:self action:@selector(shareBtnClick:)];
//    [cell.videoView.mareButton addTarget:self action:@selector(shareBtnClick:)];
//    __block  ExpandCell * weakCell=cell;
//    DBSelf(weakSelf);
////    cell.startBlock = ^{
////        [weakSelf cl_tableViewCellPlayVideoWithCell:weakCell];
////
////    };
//    cell.startBlock = ^(UIButton *btn) {
////         weakSelf.exModel=self.dataArray[indexPath.row];
////        [weakSelf play:btn withCell:weakCell];
//
//          [weakSelf cl_tableViewCellPlayVideoWithCell:weakCell];
//    };
//    return cell;
//
//
//}
//
//
//- (void)play:(UIButton *)playBtn withCell:(ExpandCell*)cell {
//    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
//    if ([systemVersion integerValue] < 9) {
//        MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.exModel.video]];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:movieVC];
//    }else{
//        playBtn.selected = !playBtn.isSelected;
//        lastPlayBtn_.selected = !lastPlayBtn_.isSelected;
//        if (lastTopicM_ != self.exModel) {
//            [playerLayer_ removeFromSuperlayer];
//            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.exModel.video]];
//            [video_player_ replaceCurrentItemWithPlayerItem:self.playerItem];
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(playerItemDidReachEnd:)
//                                                         name:AVPlayerItemDidPlayToEndTimeNotification
//                                                       object:self.playerItem];
//
//            playerLayer_.frame = self.exModel.videoF;
//            progress_.frame = CGRectMake(playerLayer_.frame.origin.x, CGRectGetMaxY(playerLayer_.frame), playerLayer_.frame.size.width, 2);
//            [cell.layer addSublayer:playerLayer_];
//
//            progress_.progress = 0;
//            [video_player_ play];
//            [avTimer_ setFireDate:[NSDate date]];
//            lastTopicM_.videoPlaying = NO;
//            self.exModel.videoPlaying = YES;
//            [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
//            [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
//        }else{
//            if(lastTopicM_.videoPlaying){
//                [video_player_ pause];
//                [avTimer_ setFireDate:[NSDate distantFuture]];
//                self.exModel.videoPlaying = NO;
//                [playBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
//            }else{
//                playerLayer_.frame = self.exModel.videoF;
//                progress_.frame = CGRectMake(playerLayer_.frame.origin.x, CGRectGetMaxY(playerLayer_.frame), playerLayer_.frame.size.width, 2);
//                [[NSNotificationCenter defaultCenter] addObserver:self
//                                                         selector:@selector(playerItemDidReachEnd:)
//                                                             name:AVPlayerItemDidPlayToEndTimeNotification
//                                                           object:self.playerItem];
//                [cell.layer addSublayer:playerLayer_];
//
//                [video_player_ play];
//                [avTimer_ setFireDate:[NSDate date]];
//                self.exModel.videoPlaying = YES;
//                [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
//            }
//        }
//
//        lastTopicM_ = self.exModel;
//        lastPlayBtn_ = playBtn;
//
//    }
//}
//
//-(void) playerItemDidReachEnd:(AVPlayerItem *)playerItem{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
//    lastTopicM_.videoPlaying = NO;
//    self.exModel.videoPlaying = NO;
//    [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
////    [self.startBtn setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
//    [video_player_ pause];
//    [video_player_ seekToTime:kCMTimeZero];
//    [playerLayer_ removeFromSuperlayer];
//    progress_.hidden = !self.exModel.videoPlaying;
//    progress_.progress = 0;
//}
//
//-(void)dealloc{
//    [video_player_ pause];
//    [playerLayer_ removeFromSuperlayer];
//    lastTopicM_.videoPlaying = NO;
//    [lastPlayBtn_ setImage:[UIImage imageNamed:@"video-play"] forState:UIControlStateNormal];
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//    //[avTimer_ invalidate];
//    //avTimer_= nil;
//}




- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGCExpandModel *model =self.dataArray[indexPath.row];
    if (model.video.length > 0) {
        return [SJTableViewCell cellHeight:model];
    } else {
        MJKWorkWorldListModel *model1 = [[MJKWorkWorldListModel alloc]init];
        model1.C_HEADIMGURL = model.salespicture;
        model1.USER_NAME = model.salesname;
        model1.OUTDATED = model.time;
        model1.C_ADDRESS = model.addressName;
        model1.urlList = model.images;
        model1.X_REMARK = model.content;
        model1.vcName = @"素材";
        return [MJKWorkWorldListCell heightForCell:model1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGCExpandModel * model=self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"0"] || [model.type isEqualToString:@"2"]) {
        MJKExpandPictureViewController *vc = [[MJKExpandPictureViewController alloc]initWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MJKExpandDetailViewController *vc = [[MJKExpandDetailViewController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//
//
//- (void)cl_tableViewCellPlayVideoWithCell:(ExpandCell *)cell {
//    //记录被点击的Cell
//    _cell = cell;
//    cell.videoView.img.hidden = NO;
//    //销毁播放器
//    [_playerView destroyPlayer];
//
//    //获取视频尺寸
//    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:cell.expand.video]];
//    NSArray *array = asset.tracks;
//    CGSize videoSize = CGSizeZero;
//
//    for (AVAssetTrack *track in array) {
//        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
//            videoSize = track.naturalSize;
//        }
//    }
//
////    CGFloat width = (KScreenWidth - 70 - 60) / videoSize.height * videoSize.width;
//
//    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(70, cell.expand.videoF.origin.y, (KScreenWidth - 70 - 60), (KScreenWidth - 70 - 60))];
//    playerView.videoFillMode = VideoFillModeResizeAspect;
//    _playerView = playerView;
//    [cell.contentView addSubview:_playerView];
//    //    //重复播放，默认不播放
//    //    _playerView.repeatPlay = YES;
//    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
//    //    _playerView.isLandscape = YES;
//    //    //设置等比例全屏拉伸，多余部分会被剪切
//    //    _playerView.fillMode = ResizeAspectFill;
//    //设置进度条背景颜色
//    _playerView.smallGestureControl=YES;
//    _playerView.progressBackgroundColor = [UIColor colorWithRed:53 / 255.0 green:53 / 255.0 blue:65 / 255.0 alpha:1];
//    //设置进度条缓冲颜色
//    _playerView.mute=NO;
//    _playerView.progressBufferColor = [UIColor grayColor];
//    //设置进度条播放完成颜色
//    _playerView.progressPlayFinishColor = [UIColor whiteColor];
//
//    //    //全屏是否隐藏状态栏
//    //    _playerView.fullStatusBarHidden = NO;
//    //    //转子颜色
//    //    _playerView.strokeColor = [UIColor redColor];
//    //视频地址
//    _playerView.url = [NSURL URLWithString:cell.expand.video];
//    //播放
//    [_playerView playVideo];
//    cell.videoView.img.hidden = YES;
//    //返回按钮点击事件回调
//    [_playerView destroyPlay:^{
////        cell.stopPlay = YES;
//        cell.videoView.img.hidden = NO;
//        NSLog(@"播放器被销毁了");
//    }];
//    [_playerView backButton:^(UIButton *button) {
//        NSLog(@"返回按钮被点击");
//    }];
//
//
//
//    //播放完成回调
//    [_playerView endPlay:^{
//        cell.videoView.img.hidden = NO;
//        //销毁播放器
//        [_playerView destroyPlayer];
//        _playerView = nil;
//        _cell = nil;
//        NSLog(@"播放完成");
//    }];
//}




//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    //销毁播放器
//    _cell.videoView.img.hidden = NO;
//    [_playerView destroyPlayer];
//      _playerView = nil;
//
//}



#pragma mark --- set
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, WIDE, HIGHT-SafeAreaBottomHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor=CGCTABBGColor;
        _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView=[[UIView alloc] init];
    }
    
    
    return _tableView;
}
-(NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSMutableArray *)deviceNOArray {
	if (!_deviceNOArray) {
		_deviceNOArray = [NSMutableArray array];
	}
	return _deviceNOArray;
}

- (UIView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
        _chooseView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, 30)];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
//            [button setImage:@"btn-下拉"];
            [button setTitleNormal:@[@"小区搜索",@"标签搜索"][i]];
            [button setTitleColor:[UIColor blackColor]];
            button.tag = i + 100;
//            button.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0);
            button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
            [button addTarget:self action:@selector(searchViewButtonAction:)];
            [_chooseView addSubview:button];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame) - 10 - 15, (30 - 6) / 2, 10, 6)];
            imageView.image = [UIImage imageNamed:@"btn-下拉"];
            [_chooseView addSubview:imageView];
            
            if (i == 0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 0, 1, 30)];
                view.backgroundColor = kBackgroundColor;
                [_chooseView addSubview:view];
                
                UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) - 1, KScreenWidth, 1)];
                bottomView.backgroundColor = kBackgroundColor;
                [_chooseView addSubview:bottomView];
                
                
            }
        }
    }
    return _chooseView;
}


//视频


//+ (NSString *)routePath {
//    return @"tableView/cell/play";
//}

//+ (void)handleRequestWithParameters:(SJParameters)parameters topViewController:(UIViewController *)topViewController completionHandler:(SJCompletionHandler)completionHandler {
//    [topViewController.navigationController pushViewController:[self new] animated:YES];
//}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    _tableView.backgroundColor = [UIColor blackColor];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.rowHeight = self.view.bounds.size.width * 9 / 16.0 + 8;
//
//    [self.view addSubview:_tableView];
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.offset(0);
//    }];
//
//    // Do any additional setup after loading the view.
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 99;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    CGCExpandModel * model=self.dataArray[indexPath.row];
    if (model.video.length > 0) {
        
    
    SJTableViewCell *cell = [SJTableViewCell cellWithTableView:tableView];
    cell.model = model;
    [cell.shareButton addTarget:self action:@selector(shareBtnClick:)];
    return cell;
    } else {
        MJKWorkWorldListCell *cell = [MJKWorkWorldListCell cellWithTableView:tableView];
        MJKWorkWorldListModel *model1 = [[MJKWorkWorldListModel alloc]init];
        model1.C_HEADIMGURL = model.salespicture;
        model1.USER_NAME = model.salesname;
        model1.OUTDATED = model.time;
        model1.urlList = model.images;
        model1.C_ADDRESS = model.addressName;
        model1.X_REMARK = model.content;
        cell.model = model1;
        cell.shareView.hidden = NO;
        [cell.shareButton addTarget:self action:@selector(shareBtnClick:)];
        cell.clickBigImgeBlock = ^(UIImageView * _Nonnull imageView) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSString *imageStr in model.images) {
                UIImageView *showImageView = [[UIImageView alloc]init];
                [showImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
                KSPhotoItem * item=[KSPhotoItem itemWithSourceView:imageView image:showImageView.image];
                [arr addObject:item];
            }
            MJKPhotoBrowser * browser=[MJKPhotoBrowser browserWithPhotoItems:arr selectedIndex:imageView.tag - 1000];
            browser.swipeUpActionBlock = ^{
                [weakSelf httpPushInfo:model];
            };
            [browser showFromViewController:weakSelf];
        };
        return cell;

    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//#ifdef DEBUG
//    NSLog(@"%d - %s", (int)__LINE__, __func__);
//#endif
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SJTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGCExpandModel * model=self.dataArray[indexPath.row];
    if (model.video.length > 0) {
        __weak typeof(self) _self = self;
        cell.view.clickedPlayButtonExeBlock = ^(SJPlayView * _Nonnull view) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            [self.player stopAndFadeOut];
            
            // create new player
            self.player = [SJVideoPlayer player];
            //        self.player.needPresentModalViewControlller = YES;
            [view.coverImageView addSubview:self.player.view];
            [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.offset(0);
            }];
            
            self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:model.video] playModel:[SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:view.coverImageView.tag atIndexPath:indexPath tableView:self.tableView]];
            self.player.URLAsset.title = @"Test Title";
            self.player.URLAsset.alwaysShowTitle = YES;
        };
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}
@end


