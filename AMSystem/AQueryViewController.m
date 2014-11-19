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
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userKey=[self.userDefaults objectForKey:@"KEY"];
    
    [AMSystemManager interfaceAttendanceReportExactToDay:userKey serachDate:@"4" complation:^(id obj) {
        if ([@"1" isEqualToString:[obj objectForKey:@"result"]]) {
            NSString *BBBB=@"START";
            NSLog(@"%@",BBBB);
            NSLog(@"%@",obj);
            [self initViews:obj[@"list"]];
//            [self initViews:[obj objectForKey:@"list"]];
        }
    }];
    
    // Do any additional setup after loading the view.
}

-(void)initViews:(NSArray *)array{
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc]init];
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
            [dict setObject:[self shortinformation] forKey:@"info"];
            [dict setObject:randomString forKey:@"day"];
            [randomArr addObject:dict];
//            [randomArr addObject:randomString];
        }
        else{
            NSLog(@"数组中有已有该随机数，重新取数！");
        }
        
    } while (randomArr.count != 10);
    return randomArr;
}
-(NSString *)shortinformation{
    NSString *str=@"正常";
    int random=arc4random()%3;
    switch (random) {
        case 0:
            str=@"请假";
            break;
        case 1:{
            str=@"旷班";
        }break;
        case 2:{
            str=@"加班";
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
        
        [self presentViewController:attendVC animated:YES completion:nil];
    }];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
