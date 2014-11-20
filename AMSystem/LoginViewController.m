//
//  ViewController.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-5.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "LoginViewController.h"
#import "AMSystemManager.h"
#import "HomeViewController.h"
#import "SignatureViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "myReachability.h"
@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *myName;
@property (strong, nonatomic) IBOutlet UITextField *myPassage;
@property (nonatomic)NSString *md5Pass;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.myPassage.text = [userDefaults stringForKey:@"passage"];
    self.myName.text = [userDefaults stringForKey:@"name"];
    self.loginBtn.layer.cornerRadius = 5;
    self.myName.delegate  = self;
    self.myPassage.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initStatusBar];
    [self initUI];
    
}

-(void)initStatusBar{
    //设置状态栏为跟随bar字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //设置bar背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38/255.0f green:109/255.0f blue:191/255.0f alpha:1.0f];
    //设置bar字体颜色
    self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1.0f];
}

-(void)initUI{
    UIView *userNameView = [self.view viewWithTag:1];
    userNameView.layer.cornerRadius = 5;
    userNameView.backgroundColor = [UIColor whiteColor];
    userNameView.layer.borderWidth = 1;
    userNameView.layer.borderColor = [[UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f]CGColor];
    
    UIView *passNameView = [self.view viewWithTag:2];
    passNameView.layer.cornerRadius = 5;
    passNameView.backgroundColor = [UIColor whiteColor];
    passNameView.layer.borderWidth = 1;
    passNameView.layer.borderColor = [[UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f]CGColor];
    
    UIButton *loginBtn = [self.view viewWithTag:3];
    loginBtn.layer.cornerRadius = 5;
}


//点击View的其他区域隐藏软键盘。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.myName resignFirstResponder];
    [self.myPassage resignFirstResponder];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-70);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (IBAction)LoginBtn:(id)sender {
    //存储用户名和密码到本地
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.myName.text forKey:@"name"];
    [userDefaults setObject:self.myPassage.text forKey:@"passage"];
    [userDefaults synchronize];
    
    if ([self.myName.text isEqualToString:@""]) {
        if ([self.myPassage.text isEqualToString:@""]) {
            UIAlertView *alertVC = [[UIAlertView alloc]initWithTitle:@"提示"
                                                             message:@"请输入用户名和密码"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
            
            [alertVC show];
        }else{
            UIAlertView *alertVC = [[UIAlertView alloc]initWithTitle:@"提示"
                                                             message:@"请输入用户名"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确定", nil];
            [alertVC show];
        }
        
    }else {
        //MD5密码加密
        const char *cStr = [self.myPassage.text UTF8String];
        unsigned char result[16];
        CC_MD5( cStr,strlen(cStr), result );
        self.md5Pass = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0],result[1],result[2],result[3],
                        result[4],result[5],result[6],result[7],
                        result[8],result[9],result[10],result[11],
                        result[12],result[13],result[14],result[15]];

        //跳转界面
        [AMSystemManager interfaceLoginByName:self.myName.text
                passWord:self.md5Pass complation:^(id obj) {
                    
                    if ([@"1" isEqualToString:[obj objectForKey:@"result"]]) {
                        
                        HomeViewController *hVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Identifier"];
                        
                        hVC.Dic = obj;
                        
                        [self.navigationController pushViewController:hVC animated:YES];//跳转
                        
                    }else if([self.myPassage.text isEqualToString:@""]){
                        UIAlertView *alertVC = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                         message:@"请输入密码"
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"确定", nil];
                        [alertVC show];
                        
                    }else{
                        UIAlertView *alertVC = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alertVC show];
                    }
                    
                }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
