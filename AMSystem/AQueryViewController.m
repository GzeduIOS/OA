//
//  AQueryViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "AQueryViewController.h"
#import "AttendanceViewController.h"
#import "AMSystemManager.h"
@interface AQueryViewController ()
@property (nonatomic ,strong)NSUserDefaults *userDefaults;
@end

@implementation AQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title  = @"考勤查询";
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userKey=[self.userDefaults objectForKey:@"KEY"];
    VRGCalendarView *calendar = [[VRGCalendarView alloc]init];
    calendar.delegate = self;
    calendar.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:calendar];
    [AMSystemManager interfaceAttendanceReportExactToMonth:userKey serachTime:@"201411" complation:^(id obj) {
//        if ([[obj objectForKey:@"result"] isEqualToString:@"1"]) {
            NSLog(@"http request seccess:%@",[obj objectForKey:@"list"]);
        if ([[obj objectForKey:@"list"] count]>0) {
            [calendar markDates:[obj objectForKey:@"list"]];
            [calendar setNeedsDisplay];
        }
        else{
            [calendar markDates:[self libRandDays]];
        }
//        [self initViews:[obj objectForKey:@"list"]];
//        }
    }];
    // Do any additional setup after loading the view.
}

-(void)initViews:(NSArray *)array{
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc]init];
    if (array.count>0) {
        [calendar markDates:array];
    }
    calendar.delegate = self;
    calendar.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:calendar];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated{
//    if (month == (int)[NSDate date]) {
//        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
//        [calendarView markDates:dates];
//    }
    [calendarView markDates:[self libRandDays]];
   
}
-(NSArray *)libRandDays{
    NSMutableArray *randomArr = [[NSMutableArray alloc] init];
    
    do {
        int random = arc4random()%29 +1;
        
        NSString *randomString = [NSString stringWithFormat:@"%d",random];
        
        if (![randomArr containsObject:randomString]) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setObject:[self infoNOR_OR_EXC_INFO] forKey:@"NOR_OR_EXC_INFO"];
            [dict setObject:[self shortinformationNOR_OR_EXC] forKey:@"NOR_OR_EXC"];
            [dict setObject:randomString forKey:@"date"];
            [randomArr addObject:dict];
//            [randomArr addObject:randomString];
        }
        else{
            NSLog(@"数组中有已有该随机数，重新取数！");
        }
        
    } while (randomArr.count != 10);
    return randomArr;
}
-(NSString *)shortinformationNOR_OR_EXC{
    NSString *str=@"0";
    int random=arc4random()%3;
    switch (random) {
        case 0:
            str=@"-1";
            break;
        case 1:{
            str=@"0";
        }break;
        case 2:{
            str=@"1";
        }break;
        default:
            break;
    }
    return str;
}
-(NSString *)infoNOR_OR_EXC_INFO{
    NSString *str=@"";
    int random=arc4random()%3;
    switch (random) {
        case 0:
            str=@"请假一天";
            break;
        case 1:{
            str=@"不好意思，今天有事，没空";
        }break;
        case 2:{
            str=@"";
        }break;
        default:
            break;
    }
    return str;
}
-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    [AMSystemManager interfaceAttendanceReportExactToDay:[self.userDefaults stringForKey:@"KEY"] serachDate:dateStr complation:^(id obj) {
        
        AttendanceViewController *attendVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"Attendance Identifier"];
        attendVC.AttendanceArr = obj;
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
        backBarButtonItem.title = @"";
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backBarButtonItem;
        [self.navigationController pushViewController:attendVC animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
