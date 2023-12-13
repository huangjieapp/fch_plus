//
//  MJKPhotoView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/26.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPhotoView.h"
#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"
#import "VideoAndImageModel.h"

#import "MJKOldCustomerSalesModel.h"

#import "MJKOldCustomerSalesViewController.h"

@interface MJKPhotoView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** scroll view*/
@property (nonatomic, strong) UIScrollView *scrollView;
/** add button*/
@property (nonatomic, strong) UIButton *addButton;
/** image url*/
@property (nonatomic, strong) NSMutableArray *urlArray;
/** image url*/
@property (nonatomic, strong) NSMutableArray *addUrlArray;
/** image view array*/
@property (nonatomic, strong) NSMutableArray *imageViewArray;
/** title name*/
@property (nonatomic, strong) UILabel *titleLabel;
/** */
@property (nonatomic, strong) UILabel *mustLabel;
@end

@implementation MJKPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initUI];
	}
	return self;
}

- (void)setTitleNameStr:(NSString *)titleNameStr {
    _titleNameStr = titleNameStr;
    CGSize size = [titleNameStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    CGRect rect = self.titleLabel.frame;
    rect.size.width = size.width;
    self.titleLabel.frame = rect;
    self.titleLabel.text = titleNameStr;
    if ([titleNameStr isEqualToString:@"评论"] || [titleNameStr isEqualToString:@"回复评论"]) {
        
        CGRect sframe = self.scrollView.frame;
        sframe.origin.y = 0;
        sframe.size.height += 20;
        self.scrollView.frame = sframe;
        
        CGRect frame = self.titleLabel.frame;
        frame.size.height = 0;
        self.titleLabel.frame = frame;
        self.titleLabel.hidden = YES;
        
        
    }
    
    if ([titleNameStr isEqualToString:@"回复评论"]) {
        
        self.scrollView.backgroundColor  = [UIColor colorWithHex:@"#efeff4"];
    }
}

- (void)initUI {
	UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
	[self addSubview:titleView];
	titleView.backgroundColor = kBackgroundColor;
	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
    self.titleLabel = titleLabel;
	titleLabel.text = @"上传图片";
	titleLabel.textColor = [UIColor darkGrayColor];
	titleLabel.font = [UIFont systemFontOfSize:14.f];
	[titleView addSubview:titleLabel];
	
    self.mustLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 5, CGRectGetMinY(titleLabel.frame) + 5, 10, 10)];
    self.mustLabel.hidden = YES;
    self.mustLabel.textColor = [UIColor redColor];
    [titleView addSubview:self.mustLabel];
    
	
	UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), self.frame.size.width, self.frame.size.height - titleView.frame.size.height)];
	scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView = scrollView;
	scrollView.backgroundColor = [UIColor whiteColor];
	[self addSubview:scrollView];
	
	CGFloat width = self.frame.size.width / 3;
	UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, width - 20, width - 20)];
	self.addButton = addButton;
	//	[button setImage:@"icon_add"];
	[addButton setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
	[scrollView addSubview:addButton];
	[addButton addTarget:self action:@selector(addImageAction:)];
	if (self.imageURLArray.count <= 0) {
		addButton.hidden = NO;
	}
	
	
	
}

- (void)setMustStr:(NSString *)mustStr {
    _mustStr = mustStr;
    self.mustLabel.text = mustStr;
    self.mustLabel.hidden = NO;
}

- (void)setImageURLArray:(NSArray *)imageURLArray {
	_imageURLArray = imageURLArray;
	[self.urlArray removeAllObjects];
	[self.addUrlArray removeAllObjects];
	
	[self.urlArray addObjectsFromArray:imageURLArray];
//	NSString *str = @"http://7xt9pc.com1.z0.glb.clouddn.com/";//图片前缀
    for (NSString *str in imageURLArray) {
        if ([str rangeOfString:@"http://cdn.51mcr.com"].location != NSNotFound) {
            [self.addUrlArray addObject:[str substringWithRange:NSMakeRange(@"http://cdn.51mcr.com".length, str.length - @"http://cdn.51mcr.com".length)]];
        } else {
            [self.addUrlArray addObject:str];
        }
    }
//	[self.addUrlArray addObjectsFromArray:imageURLArray];
		for (UIImageView *imageView in self.imageViewArray) {
			[imageView removeFromSuperview];
		}
	[self.imageViewArray removeAllObjects];
	for (int i = 0; i < imageURLArray.count; i++) {
		UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 + ((self.addButton.frame.size.width + 10) * i) , 10, self.addButton.frame.size.width, self.addButton.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
		[self.scrollView addSubview:imageView];
		imageView.layer.cornerRadius = 5.f;
		imageView.layer.masksToBounds = YES;
		imageView.tag = i + 100;
		UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
		[imageView addGestureRecognizer:tapGR];
		if (imageURLArray.count > 0) {
            if ([imageURLArray[i] isKindOfClass:[NSString class]]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageURLArray[i]]];
            } else {
                imageView.image = [UIImage imageWithData:imageURLArray[i]];
            }
		}
		[self.imageViewArray addObject:imageView];
		UIButton *delButton = [[UIButton alloc]initWithFrame:CGRectMake(imageView.frame.size.width - 20, 0, 20, 20)];
		[imageView addSubview:delButton];
		imageView.userInteractionEnabled = YES;
		[delButton addTarget:self action:@selector(deleteImage:)];
		delButton.tag = i;
		[delButton setImage:@"icon_delete"];
		delButton.hidden = YES;
		if (self.isEdit == YES) {
			delButton.hidden = NO;
		}
		
	}
	CGRect addFrame = self.addButton.frame;
	addFrame.origin.x = imageURLArray.count * (addFrame.size.width + 10 ) + 20;
	self.addButton.frame = addFrame;
	if (self.isEdit == YES) {
		self.addButton.hidden = NO;
		self.scrollView.contentSize = CGSizeMake(self.addButton.frame.origin.x + self.addButton.frame.size.width + 20, self.scrollView.frame.size.height);
	} else {
		self.addButton.hidden = YES;
		self.scrollView.contentSize = CGSizeMake(self.addButton.frame.origin.x + 10, self.scrollView.frame.size.height);
		self.addButton.hidden = YES;
	}
    
    if (self.imageCount != 0) {
        if (self.addUrlArray.count == self.imageCount) {
            self.addButton.hidden = YES;
        }
    }
	
	
	if (self.backUrlArray) {
		self.backUrlArray(self.urlArray, self.addUrlArray);
	}
//    if (self.backSaveUrlArray) {
//        self.backSaveUrlArray(self.addUrlArray);
//    }
    
}

- (void)deleteImage:(UIButton *)sender {
	[self.addUrlArray removeObjectAtIndex:sender.tag];
	[self.urlArray removeObjectAtIndex:sender.tag];
	self.imageURLArray = [self.urlArray copy];
}

- (void)showBigImage:(UITapGestureRecognizer *)sender {
	UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
	
	UIImageView *views = (UIImageView*) tap.view;
	NSMutableArray *arr = [NSMutableArray array];
	for (UIImageView *imageView in self.imageViewArray) {
		KSPhotoItem * item=[KSPhotoItem itemWithSourceView:imageView image:imageView.image];
		[arr addObject:item];
		
	}
	KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:arr selectedIndex:views.tag - 100];
	
	
	[browser showFromViewController:self.rootVC];
	
}

- (void)addImageAction:(UIButton *)sender {
	UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	
	
	UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.allowsEditing = NO;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
		[self.rootVC presentViewController:imagePicker animated:YES completion:nil];
		
	}];
	UIAlertAction*manual=[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
		
		UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
		if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
		{
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			//设置拍照后的图片可被编辑
			picker.allowsEditing = NO;
			picker.sourceType = sourceType;
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
			[self.rootVC presentViewController:picker animated:YES completion:nil];
			
		}else
		{
			NSLog(@"模拟其中无法打开照相机,请在真机中使用");
		}
		
		
	}];
	if (self.isCamera == NO) {
		[alertVC addAction:sanfdal];
	}
	
	[alertVC addAction:manual];
	[alertVC addAction:cancel];
	[self.rootVC presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -- 上传图片相关

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	
	
	//当选择的类型是图片
	if ([type isEqualToString:@"public.image"])
	{
		//先把图片转成NSData
		UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerEditedImage];
		}
		//设置image的尺寸
		//        CGSize imagesize = image.size;
		//        imagesize.height =500;
		//        imagesize.width =500;
		//        //对图片大小进行压缩--
		//        image = [self imageWithImage:image scaledToSize:imagesize];
		NSData *imageData = UIImageJPEGRepresentation(image,0.1);
		image= [UIImage imageWithData:imageData];
		
        if (self.backDataImage == YES) {
       
            [self.urlArray addObject:imageData];
             [self.addUrlArray addObject:imageData];
             self.imageURLArray = [self.urlArray copy];
          
        } else {
        
//		[self saveimg:image];
//            if ([self.rootVC isKindOfClass:[MJKOldCustomerSalesViewController class]]) {
                [self httpUpdateQiniuWithUrl:imageData];
//            } else {
//		[self uppicAction:imageData];
//
//            }
        }
		
	}else{
		UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
		if (!image) {
			image=[info objectForKey:UIImagePickerControllerOriginalImage];
		}
		//设置image的尺寸
		//        CGSize imagesize = image.size;
		//        imagesize.height =626;
		//        imagesize.width =413;
		//        //对图片大小进行压缩--
		//        image = [self imageWithImage:image scaledToSize:imagesize];
		NSData *imageData = UIImageJPEGRepresentation(image,0.1);
		image= [UIImage imageWithData:imageData];
        
        if (self.backDataImage == YES) {
        
        
        
            [self.urlArray addObject:imageData];
            [self.addUrlArray addObject:imageData];
            self.imageURLArray = [self.urlArray copy];
           
        } else {
		
		
//		[self saveimg:image];
//            if ([self.rootVC isKindOfClass:[MJKOldCustomerSalesViewController class]]) {
                [self httpUpdateQiniuWithUrl:imageData];
//            } else {
//            [self uppicAction:imageData];
//            }
        }
	}
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	
}

- (void)httpUpdateQiniuWithUrl:(NSData *)imageData {
    DBSelf(weakSelf);
  
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataQiNiuUpDataFileWithUrl:HTTP_UploadByQiNiu parameters:nil file:imageData andFileName:@"headimage.png" andMimeType:@".png" compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            VideoAndImageModel *model = [VideoAndImageModel mj_objectWithKeyValues:data];
            NSString * imgUrl = [data objectForKey:@"url"];//回传
//            [self setPicBtn:imgUrl];
        [weakSelf.urlArray addObject:model.url];
            [weakSelf.addUrlArray addObject:model.saveUrl];
            weakSelf.imageURLArray = [weakSelf.urlArray copy];
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
////对图片尺寸进行压缩--
//-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    // End the context
//    UIGraphicsEndImageContext();
//
//    // Return the new image.
//    return newImage;
//}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"您取消了选择图片");
	[picker dismissViewControllerAnimated:YES completion:nil];
}
//储存图像到本地
- (void)saveimg:(UIImage *) img
{
	NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss:SSS"];
	NSString *date =  [formatter stringFromDate:[NSDate date]];
	
	NSString *imgname =  [NSString stringWithFormat:@"/image%@.png",date];
	imgname = [imgname stringByReplacingOccurrencesOfString:@" " withString:@""];
	imgname = [imgname stringByReplacingOccurrencesOfString:@":" withString:@""];
	
	//这里将图片放在沙盒的documents文件夹中
	NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	//文件管理器
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
	[fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
	NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
	[fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imgname] contents:dataObj attributes:nil];
	//得到选择后沙盒中图片的完整路径
//	self.patchUrl = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imgname];
	
}

-(void)uppicAction:(NSData *)data{
	DBSelf(weakSelf);
	
	
	//    NSData *data=[NSData dataWithContentsOfFile:self.patchUrl];
	NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
	HttpManager *manager = [[HttpManager alloc]init];
	[manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue] == 200) {
			NSString * imgUrl = [data objectForKey:@"url"];//回传
//			[self setPicBtn:imgUrl];
		[weakSelf.urlArray addObject:[data objectForKey:@"show_url"]];
			[weakSelf.addUrlArray addObject:imgUrl];
			weakSelf.imageURLArray = [weakSelf.urlArray copy];
		} else {
			[JRToast showWithText:data[@"message"]];
		}
	}];
	
}

- (NSMutableArray *)urlArray {
	if (!_urlArray) {
		_urlArray = [NSMutableArray array];
	}
	return _urlArray;
}

- (NSMutableArray *)addUrlArray {
	if (!_addUrlArray) {
		_addUrlArray = [NSMutableArray array];
	}
	return _addUrlArray;
}

- (NSMutableArray *)imageViewArray {
	if (!_imageViewArray) {
		_imageViewArray = [NSMutableArray array];
	}
	return _imageViewArray;
}

@end
