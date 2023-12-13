//
//  SingleLocationViewController.m
//  officialDemoLoc
//
//  Created by 刘博 on 15/9/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "SingleLocationViewController.h"
#import "ShakeSignInView.h"
#import "CGCOrderDetialFooter.h"
#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"
#import "AddCustomerChooseTableViewCell.h"

#import "MJKSingleModel.h"


#import "WorkCalendartListViewController.h"
#import "CGCNewAppointTextCell.h"

#import "MJKPhotoView.h"

#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3

#define chooseCell    @"AddCustomerChooseTableViewCell"
#define RemarkCell    @"CGCNewAppointTextCell"

@interface SingleLocationViewController () <MAMapViewDelegate, AMapLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;

@property(nonatomic,strong)NSMutableDictionary *saveFooterImageDataDic;
@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0

@property(nonatomic,strong)ShakeSignInView*signInView;
@property(nonatomic,assign)CLLocationCoordinate2D locationCoordinate;
@property(nonatomic,strong)NSString*localAddress;  //地址
@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;

@property(nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) MJKSingleModel *model;
@property(nonatomic, strong) NSMutableArray *saveFooterImageAddress;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** 图片 address*/
@property (nonatomic, strong) NSArray *imageUrlArray;
@end

@implementation SingleLocationViewController

#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    
    //设置开启虚拟定位风险监测，可以根据需要开启
    [self.locationManager setDetectRiskOfFakeLocation:NO];
}

#pragma mark  -- image delegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
//    NSData*data=UIImagePNGRepresentation(newPhoto);
    NSData *data = UIImageJPEGRepresentation(newPhoto, .1f);
    //    //吊接口  照片
    //    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    UIImageView*imageView=[cell viewWithTag:111];
    //    imageView.image=newPhoto;
    
//    [self httpPostArrayImage:data];
    
    if (self.selectedImage==11){
        //footer 第一张图
        [self.saveFooterImageDataDic setObject:data forKey:@"11"];
        self.footerImageView.firstImg=newPhoto;
        
        
    }else if (self.selectedImage==22){
        //footer 第二张图
        [self.saveFooterImageDataDic setObject:data forKey:@"22"];
        self.footerImageView.secondImg=newPhoto;
        
        
        
    }else if (self.selectedImage==33){
        //footer 第三张图
        [self.saveFooterImageDataDic setObject:data forKey:@"33"];
        self.footerImageView.thirdImg=newPhoto;
        
        
    }
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];

    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

#pragma mark - Initialization

- (void)initCompleteBlock
{
    __weak SingleLocationViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //根据定位信息，添加annotation
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        [annotation setCoordinate:location.coordinate];
        
        //有无逆地理信息，annotationView的标题显示的字段不一样
        if (regeocode)
        {
			NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@",
									regeocode.city.length > 0 ? regeocode.city: @"",
									regeocode.district.length > 0 ? regeocode.district: @"",
									regeocode.street.length > 0 ? regeocode.street: @"",
									regeocode.number.length > 0 ? regeocode.number: @""];
            [annotation setTitle:[NSString stringWithFormat:@"%@", addressStr]];
            [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
        }
        else
        {
            [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
            [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
        }
        
        SingleLocationViewController *strongSelf = weakSelf;
        [strongSelf addAnnotationToMapView:annotation];
        
        
        //
        if (location.coordinate.latitude&&location.coordinate.longitude) {
            weakSelf.locationCoordinate=location.coordinate;
        }
        if (regeocode) {
            weakSelf.localAddress=regeocode.formattedAddress;
        }
        
        
        
    };
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:15.1 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - 400 - SafeAreaBottomHeight)];
        [self.mapView setDelegate:self];
        
        [self.view addSubview:self.mapView];
    }
}

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    UIBarButtonItem *reGeocodeItem = [[UIBarButtonItem alloc] initWithTitle:@"带逆地理定位"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(reGeocodeAction)];
    
    UIBarButtonItem *locItem = [[UIBarButtonItem alloc] initWithTitle:@"不带逆地理定位"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(locAction)];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, reGeocodeItem, flexble, locItem, flexble, nil];
}

- (void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clean"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(cleanUpAction)];
    
    self.toolbarItems=nil;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    [self initToolBar];
    
//    [self initNavigationBar];
    
    [self initMapView];
    
    [self initCompleteBlock];
    
    [self configLocationManager];
    
    
    if (self.locateType==LocatedTypeShakeIt) {
         self.title=@"签到";
        [self addBottomView];
        [self addRightNaviItem];
        
        [self reGeocodeAction];

    }else if (self.locateType==LocatedTypeShowMap){
        self.title=@"定位";
        [self showMap];
        
    }
    [self.tableview registerNib:[UINib nibWithNibName:chooseCell bundle:nil] forCellReuseIdentifier:chooseCell];
    [self.tableview registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
    [self.view addSubview:self.tableview];
    self.model = [[MJKSingleModel alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.navigationController.toolbar.translucent   = YES;
//    self.navigationController.toolbarHidden         = NO;
}

- (void)dealloc
{
    [self cleanUpAction];
    
    self.completionBlock = nil;
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.row == 0) {
        AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
        cell.Type=ChooseTableViewTypeChooseCustomer;
        cell.chooseTextField.text = self.model.C_A41500_C_NAME;
        cell.nameTitleLabel.text = @"客户";
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            NSArray *strArray = [str componentsSeparatedByString:@","];
            weakSelf.model.C_A41500_C_NAME = strArray[0];
            weakSelf.model.C_A41500_C_ID = postValue;
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    } else {
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
        cell.topTitleLabel.text = @"备注";
//        cell.textView.delegate = self;
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.X_REMARK = textStr;
//            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
		cell.startInputBlock = ^{
			[UIView animateWithDuration:.5 animations:^{
				self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y- 200,self.tableview.frame.size.width,self.tableview.frame.size.height);
				
				
			}];
		};
		cell.endBlock = ^{
			[UIView animateWithDuration:.5 animations:^{
				self.tableview.frame=CGRectMake(0, CGRectGetMaxY(self.mapView.frame),self.tableview.frame.size.width,self.tableview.frame.size.height);
				
				
			}];
		};
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    } else {
        return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DBSelf(weakSelf);
    /*CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
    //        footer.beforeImageArray=self.saveFooterUrlArray;
    footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
    self.footerImageView=footer;
    footer.clickFirstBlock = ^(UIImage*image){
        if (image) {
            //有图片那就放大
            MyLog(@"放大");
            
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.firstPicBtn.imageView image:image];
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
            //                browser.delegate = self;
            //                browser.dismissalStyle = _dismissalStyle;
            //                browser.backgroundStyle = _backgroundStyle;
            //                browser.loadingStyle = _loadingStyle;
            //                browser.pageindicatorStyle = _pageindicatorStyle;
            //                browser.bounces = _bounces;
            [browser showFromViewController:self];
            
            
            
            
        }else{
            //选择图片
            self.selectedImage=11;
//            [weakSelf TouchAddImage];
			[weakSelf addImage];
			
        }
        
    };
    
    footer.clickSecondBlock = ^(UIImage*image){
        if (image) {
            //有图片那就放大
            MyLog(@"放大");
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.secondPicBtn.imageView image:image];
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
            [browser showFromViewController:self];
            
            
        }else{
            //选择图片
            self.selectedImage=22;
//            [weakSelf TouchAddImage];
			[weakSelf addImage];
            
        }
        
        
        
    };
    
    footer.clickThirdBlock = ^(UIImage*image){
        if (image) {
            //有图片那就放大
            MyLog(@"放大");
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.thirdPicBtn.imageView image:image];
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
            [browser showFromViewController:self];
            
            
        }else{
            //选择图片
            self.selectedImage=33;
//            [weakSelf TouchAddImage];
			[weakSelf addImage];
			
            
        }
        
    };
    
    
    
    
    //删除图片
    footer.deleteFirstBlock = ^{
        [self.saveFooterImageDataDic removeObjectForKey:@"11"];
        
        
        
    };
    
    footer.deleteSecondBlock = ^{
        [self.saveFooterImageDataDic removeObjectForKey:@"22"];
        
        
    };
    
    footer.deleteThirdBlock = ^{
        [self.saveFooterImageDataDic removeObjectForKey:@"33"];
        
        
    };
    return footer;*/
	return self.tableFootPhoto;
}

- (MJKPhotoView *)tableFootPhoto {
	DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = YES;
		_tableFootPhoto.isCamera = YES;
		_tableFootPhoto.rootVC = self;
		_tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
			weakSelf.imageUrlArray = arr;
		};
	}
	return _tableFootPhoto;
}

- (void)addImage {
	UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	
	[alertVC addAction:[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
#if TARGET_IPHONE_SIMULATOR
		MyLog(@"模拟");
		
		
#elif TARGET_OS_IPHONE
		UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
		imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
		imagePicker.allowsEditing=NO;
		imagePicker.delegate=self;
		[self presentViewController:imagePicker animated:YES completion:nil];
		
#endif
		
		
		
	}]];
	
	[alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
	
	[self presentViewController:alertVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 150;
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = NO;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
		CGSize size = [self.addressStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options: NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.f]} context:nil].size;
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, 30)];
		label.text = self.addressStr;
		annotationView.rightCalloutAccessoryView = label;
        return annotationView;
    }
    
    return nil;
}






#pragma mark  --funcation
-(void)addRightNaviItem{
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    rightItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)clickRightItem{
    WorkCalendartListViewController*vc=[[WorkCalendartListViewController alloc]init];
    vc.calendarType=workCalendartListTypeShakeit;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)addBottomView{
    
    UIButton *singleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - 40, KScreenWidth, 40)];
    [singleButton setTitle:@"签到" forState:UIControlStateNormal];
    [singleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    singleButton.backgroundColor = DBColor(252, 202, 75);
    [self.view addSubview:singleButton];
    [singleButton addTarget:self action:@selector(singleButtonAction) forControlEvents:UIControlEventTouchUpInside];
 /* DBSelf(weakSelf);
    ShakeSignInView*signInView=[ShakeSignInView creatShakeSignInView];
    signInView.frame=CGRectMake(0, KScreenHeight-295, KScreenWidth, 295);
    self.signInView=signInView;
    self.signInView.clickCompleteBlock = ^(NSString *textStr) {
        MyLog(@"%@",textStr);
        NSString*textSt;
        if (!textStr) {
            textSt=@"";
        }else{
            textSt=textStr;
        }
//        [weakSelf httpPostSignInWithRemark:textSt];
        
    };
    */
//    [self.view addSubview:signInView];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
}
#pragma mark 签到按钮
- (void)singleButtonAction {
    DBSelf(weakSelf);
//    [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
//        NSString*X_PICURLStr=[arrayImg componentsJoinedByString:@","];
        [weakSelf httpPostSignInWithImageStr:self.imageUrlArray];
        
//    }];
}

//上传多张照片  并完成
//选完就上传图片
-(void)httpPostArrayImage:(NSData *)imageData {
    DBSelf(weakSelf);
    NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:imageData compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            NSString*imageStr=data[@"show_url"];
            [weakSelf.saveFooterImageAddress addObject:imageStr];
            
            
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
}

-(void)httpPostArrayImage:(NSMutableDictionary*)ImageDic compliete:(void(^)(NSArray*arrayImg))successBlock{
    DBSelf(weakSelf);
    NSMutableArray*ImageArray=[NSMutableArray array];
    [ImageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ImageArray addObject:obj];
    }];
    
    
    if (ImageArray.count<1) {
        successBlock(nil);
    }else{
        
//        NSMutableArray*saveFooterImageAddress=[NSMutableArray array];
        for (NSData*imageData in ImageArray) {
            NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
            HttpManager*manager=[[HttpManager alloc]init];
            [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:imageData compliation:^(id data, NSError *error) {
                MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
                    
                    NSString*imageStr=data[@"show_url"];
                    [weakSelf.saveFooterImageAddress addObject:imageStr];
                    
                    if (weakSelf.saveFooterImageAddress.count==ImageArray.count) {
                        successBlock(weakSelf.saveFooterImageAddress);
                    }
                    
                    
                    
                }else{
                    [JRToast showWithText:data[@"message"]];
                }
                
            }];
            
        }
        
        
        
    }
}


//-(void)KeyboardShow:(NSNotification*)notif{
//    NSDictionary*userInfo=notif.userInfo;
//    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
//
//    CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
//    CGFloat keyStartY=[userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].origin.y;
//
//    //-260
//    CGFloat delaty=keyEndY-keyStartY;
//
//
//    [UIView animateWithDuration:duration animations:^{
//        self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y+delaty,self.tableview.frame.size.width,self.tableview.frame.size.height);
//
//
//    }];
//
//
//}
//
//-(void)keyBoardHidden:(NSNotification*)notif{
//    NSDictionary*userInfo=notif.userInfo;
//    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
//
//    CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
//    CGFloat keyStartY=[userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].origin.y;
//
//    //260
//    CGFloat delaty=keyEndY-keyStartY;
//
//
//    [UIView animateWithDuration:duration animations:^{
//        self.tableview.frame=CGRectMake(0, CGRectGetMaxY(self.mapView.frame),self.tableview.frame.size.width,self.tableview.frame.size.height);
//
//
//    }];
//
//
//
//}

/*- (void)textViewDidBeginEditing:(UITextView *)textView {
//    NSDictionary*userInfo=notif.userInfo;
//    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
//
//    CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
//    CGFloat keyStartY=[userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].origin.y;
//
//    //-260
//    CGFloat delaty=keyEndY-keyStartY;
    
    
    [UIView animateWithDuration:.5 animations:^{
        self.tableview.frame=CGRectMake(0, self.tableview.frame.origin.y- 200,self.tableview.frame.size.width,self.tableview.frame.size.height);
        
        
    }];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
//    NSDictionary*userInfo=notif.userInfo;
//    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
//
//    CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
//    CGFloat keyStartY=[userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].origin.y;
//
//    //260
//    CGFloat delaty=keyEndY-keyStartY;
    
    
    [UIView animateWithDuration:.5 animations:^{
        self.tableview.frame=CGRectMake(0, CGRectGetMaxY(self.mapView.frame),self.tableview.frame.size.width,self.tableview.frame.size.height);
        
        
    }];
}*/

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.signInView.inputTextField resignFirstResponder];
//    
//}

- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{
     [self.signInView.inputTextField resignFirstResponder];
    
}


//接口
-(void)httpPostSignInWithImageStr:(NSArray*)imageArray{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"ReservationWebService-insertSign"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:[DBObjectTools getShakeSignInC_id] forKey:@"C_ID"];
    [contentDict setObject:[DBTools getTimeFomatFromCurrentTimeStamp] forKey:@"D_FOLLOW_TIME"];
    if (self.locationCoordinate.longitude&&self.locationCoordinate.latitude) {
        [contentDict setObject:@(self.locationCoordinate.longitude) forKey:@"B_DRIVE_LON"];
        [contentDict setObject:@(self.locationCoordinate.latitude) forKey:@"B_DRIVE_LAT"];
    }else{
        [contentDict setObject:@"" forKey:@"B_DRIVE_LON"];
        [contentDict setObject:@"" forKey:@"B_DRIVE_LAT"];
    }
    
    if (self.model.C_A41500_C_ID.length > 0) {
        contentDict[@"C_A41500_C_ID"] = self.model.C_A41500_C_ID;
        contentDict[@"C_A41500_C_NAME"] = self.model.C_A41500_C_NAME;
    } /*else {
        contentDict[@"C_A41500_C_ID"] = @"";
        contentDict[@"C_A41500_C_NAME"] = @"";
    }*/
    [contentDict setObject:self.localAddress.length > 0 ? self.localAddress : @"" forKey:@"C_DRIVE_ADDRESS"];
    NSString *str = self.model.X_REMARK;
//	if (self.model.X_REMARK.length > 0) {
//		 str = [NSString stringWithFormat:@"%@-%@",self.localAddress, self.model.X_REMARK ];
//	} else {
//		str = self.localAddress;
//	}
	if (str.length > 0) {
		[contentDict setObject:str > 0 ? str : @"" forKey:@"X_REMARK"];
	}
        
    
  
    contentDict[@"urlList"] = imageArray.count > 0 ? imageArray : @[];
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
             [JRToast showWithText:data[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
    
    
}


-(NSMutableDictionary *)saveFooterImageDataDic{
    if (!_saveFooterImageDataDic) {
        _saveFooterImageDataDic=[NSMutableDictionary dictionary];
    }
    return _saveFooterImageDataDic;
}

#pragma mark  -- 展示地图上的点
-(void)showMap{
    //根据定位信息，添加annotation
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    [annotation setCoordinate:self.PubCoordinate];

   
    [self addAnnotationToMapView:annotation];

    
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), KScreenWidth, 300)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.bounces = NO;
        
    }
    return _tableview;
}

- (NSMutableArray *)saveFooterImageAddress {
    if (!_saveFooterImageAddress) {
        _saveFooterImageAddress = [NSMutableArray array];
    }
    return _saveFooterImageAddress;
}

@end
