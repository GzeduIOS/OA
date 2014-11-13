//
//  myReachability.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-29.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "myReachability.h"

@implementation myReachability
-(void)myreachability:(UIView *)myview{
    self.blockLabel = [[UILabel alloc]initWithFrame:CGRectMake(myview.frame.size.width/2-50, myview.frame.size.height-100, 100, 40)];
    self.blockLabel.textAlignment = NSTextAlignmentCenter;
    self.blockLabel.font = [UIFont systemFontOfSize:15];
    self.blockLabel.hidden = NO;
    self.blockLabel.backgroundColor = [UIColor blackColor];
    self.blockLabel.textColor = [UIColor whiteColor];
    
    UIView *backview = [[UIView alloc]init];
    backview.frame = myview.frame;
    backview.backgroundColor = [UIColor clearColor];
    [backview addSubview:self.blockLabel];
    [myview addSubview:backview];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            backview.hidden = YES;
            self.blockLabel.text = @"Block Says Reachable";
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blockLabel.text = @"加载失败...";
            backview.hidden = NO;
            
        });
    };
    
    [reach startNotifier];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        self.notificationLabel.text = @"Notification Says Reachable";
    }
    else
    {
        self.notificationLabel.text = @"网络没连接...";
    }
}
@end
