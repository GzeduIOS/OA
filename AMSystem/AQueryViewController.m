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
    VRGCalendarView *calendar = [[VRGCalendarView alloc]init];
    calendar.delegate = self;
    calendar.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.width);
    [self.view addSubview:calendar];
    
    // Do any additional setup after loading the view.
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated{
    if (month == (int)[NSDate date]) {
        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
        [calendarView markDates:dates];
    }
   
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
