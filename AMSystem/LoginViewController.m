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
}
//点击Enter的时候隐藏软键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.myName resignFirstResponder];
    [self.myPassage resignFirstResponder];
    return YES;
}
//点击取消（Cancel）或那个小差号的时候隐藏。注意这里如return YES则无法隐藏
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    [self.myName resignFirstResponder];
    [self.myPassage resignFirstResponder];
    return NO;
}
//点击View的其他区域隐藏软键盘。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.myName resignFirstResponder];
    [self.myPassage resignFirstResponder];
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
                        
                        [self presentViewController:hVC animated:YES completion:nil];//跳转
                        
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
