//
//  SignatureViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "SignatureViewController.h"
#import "AMSystemManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface SignatureViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;//签到//日记//签退
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *rephotoButton;
@property (weak, nonatomic) IBOutlet UIView *sumitInfoView;
@property (weak, nonatomic) IBOutlet UILabel *sumitInfoView_typeLable;
@property (weak, nonatomic) IBOutlet UILabel *sumitInfoView_timeLable;
@property (weak, nonatomic) IBOutlet UILabel *sumitInfoView_locationLable;
@property (weak, nonatomic) IBOutlet UIButton *sumitInfoView_reselectButton;
@property (weak, nonatomic) IBOutlet UIButton *sumitInfoView_submitButton;
@property (weak, nonatomic) IBOutlet UILabel *remiderLable;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageVIew;

@property (strong, nonatomic)NSMutableArray *arrImage;
@property (strong, nonatomic)NSString *adder;//用于提交时发送地址
@property (nonatomic)NSUInteger *tag;//签到类型
@property(strong,nonatomic)NSArray *fileArray;
@property(strong,nonatomic)NSString *strPath;
@property (strong,nonatomic)NSData *imagedata;
@property(strong,nonatomic)NSString *strName;

@property CLLocationManager *locationManager;//MapAPI
@property CLLocation *location;//MapAPI - 记录地理信息
@end

@implementation SignatureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//隐藏状态栏
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrImage = [[NSMutableArray alloc]init];
    self.title = @"考勤签到";
    self.photoImageView.hidden = YES;//隐藏imageview
    self.rephotoButton.hidden = YES;//隐藏rephotobutton
    self.sumitInfoView.hidden = YES;//隐藏submitinfoView
    self.arrowImageVIew.hidden = YES ;//隐藏arrowImageView
    //Location API init
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//精确到10米
    self.locationManager.distanceFilter = 1000.0f;
    
    //三个按钮de点击切换图
    self.btn1.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.btn1.layer.borderWidth = 1;
    self.btn2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.btn2.layer.borderWidth = 1;
    self.btn3.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.btn3.layer.borderWidth = 1;
    
}
//准备显示视图
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始定位
    [self.locationManager startUpdatingLocation];
}
//准备关闭视图
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关闭定位
    [self.locationManager stopUpdatingLocation];
}
//MapAPI委托方法 更新地址后回调赋值地理信息
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.location = [locations lastObject];
}

//签到//日记//签退
- (IBAction)btn1:(UIButton *)sender {
    UIImage *image = [[UIImage alloc]init];
    if (sender.tag == 0) {
        image = [UIImage imageNamed:@"attendance1-1.png"];
    }else if (sender.tag == 1){
        image = [UIImage imageNamed:@"attendance2-2.png"];
    }else{
        image = [UIImage imageNamed:@"attendance3-3.png"];
    }
    [sender setImage:image forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithRed:38/255.0f green:109/255.0f blue:191/255.0f alpha:1.0f] forState:UIControlStateNormal];
    self.tag = (NSUInteger *)sender.tag;
    self.sumitInfoView_typeLable.text = sender.titleLabel.text;
    [self showInfo];//展示信息
}
//展示信息
- (void)showInfo{
    
    //反编码地理信息,取得地址信息
    CLGeocoder* geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error){

        if([placemarks count] > 0){
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *locationInfos = placemark.addressDictionary;
            
            //绘制信息
            [self createLocationInfo:locationInfos];
        }
        
    }];
   
}
//绘制地址及时间显示
-(void)createLocationInfo:(NSDictionary *)locationInfos
{
    //地址
    NSString *city = [locationInfos valueForKey:@"City"];//市
  //  NSString *subLocality = [locationInfos valueForKey:@"SubLocality"];//区
    NSString *thoroughfare = [locationInfos valueForKey:@"Thoroughfare"];//街道
    NSString *state = [locationInfos valueForKey:@"State"];//省
    NSMutableString *address = [NSMutableString stringWithCapacity:100];
    [address appendString:state];
    [address appendString:city];
 // [address appendString:subLocality];
    [address appendString:thoroughfare];
    
    self.adder = address;//用于提交时发送
    self.sumitInfoView_locationLable.text = [NSString stringWithFormat:@"%@",address];
    //签到时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *addartime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[dateString substringWithRange:NSMakeRange(0, 4)],[dateString substringWithRange:NSMakeRange(4, 2)],[dateString substringWithRange:NSMakeRange(6, 2)],[dateString substringWithRange:NSMakeRange(8, 2)],[dateString substringWithRange:NSMakeRange(10, 2)]];
    
    self.sumitInfoView_timeLable.text = [NSString stringWithFormat:@"%@",addartime];

    //提交按钮
    [self.sumitInfoView_submitButton addTarget:self action:@selector(chickUp:) forControlEvents:UIControlEventTouchUpInside];
    //重选按钮
    [self.sumitInfoView_reselectButton addTarget:self action:@selector(reselectInfo) forControlEvents:UIControlEventTouchUpInside];
    self.btn1.hidden = YES;//隐藏原有的三个按钮
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.remiderLable.hidden = YES;
    self.sumitInfoView.hidden = NO;
}
//调用照相机
- (IBAction)photoBtn:(UIButton *)sender {
    [self takePhoto];
}
//调用照相机方法
-(void)takePhoto{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        //判断是否可以打开相机，模拟器此功能无法使用
        if( [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        imagePicker.delegate = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:imagePicker animated:YES completion:nil];
        });
        
    });

}
//重选方法
-(void)reselectInfo{
    self.photoImageView.hidden = YES;//隐藏imageview
    self.rephotoButton.hidden = YES;//隐藏rephotobutton
    self.sumitInfoView.hidden = YES;//隐藏submitinfoView
    self.arrowImageVIew.hidden = YES ;//隐藏arrowImageView
    
    //显示隐藏的三按钮。并把状态恢复
    self.btn1.hidden = NO;
    self.btn2.hidden = NO;
    self.btn3.hidden = NO;
    [self.btn1 setImage:[UIImage imageNamed:@"attendance1.png"] forState:UIControlStateNormal];
    [self.btn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"attendance2.png"] forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btn3 setImage:[UIImage imageNamed:@"attendance3.png"] forState:UIControlStateNormal];
    [self.btn3 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.remiderLable.hidden = NO;
    self.photoBtn.hidden = NO;
    self.remiderLable.text = @"请点击打开相机拍照签到或直接选择以下方式签到";
    
}
//保存照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    
    self.imagedata = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage],0.000001);
    UIImage *img = [[UIImage alloc]initWithData:self.imagedata];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.photoBtn.hidden = YES;
        self.photoImageView.hidden = NO;
        self.rephotoButton.hidden = NO;
        if (self.sumitInfoView.hidden == YES) {
            self.arrowImageVIew.hidden = NO;
            self.remiderLable.text = @"请选择以下方式签到";
        }else{
            self.remiderLable.hidden = YES;
        }
        
        self.photoImageView.image = img;
        
        [self.arrImage addObject:self.imagedata];
        MyLog(@"%u",[self.imagedata length]/1024);
        [self.rephotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self dismissViewControllerAnimated:YES completion:nil];//关闭拍照后选择界面
    });
   // UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);//把拍照图片保存到本地
    
}

//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];//关闭拍照界面
    
}

//提交返回
-(void)chickUp:(UIButton *)sender{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //经纬度
        NSString *longitude = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
        NSString *latitude = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];

        //接口请求KEY
        NSString *KEY = [self.SignatureDic objectForKey:@"KEY"];
        
        //签到类型
        sender.tag = (NSUInteger)self.tag;
        NSString *ROLE_CODE = [[NSString alloc]init];
        
        if (sender.tag == 0) {
            ROLE_CODE = @"A";
        }else if(sender.tag == 1){
            ROLE_CODE = @"C";
        }else if(sender.tag == 2){
            ROLE_CODE = @"B";
        }
        //返回接口返回值(NSDictionary)
        [AMSystemManager interfaceRegister:KEY userSignType:ROLE_CODE userSignAddress:self.adder userLongitude:longitude userLatitude:latitude pictureData:self.imagedata complation:^(id obj) {
            MyLog(@"%@",obj);
            [self.navigationController popViewControllerAnimated:YES];//关闭签到界面
            
        }];
        
    });
   
}
@end
