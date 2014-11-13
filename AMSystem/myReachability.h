//
//  myReachability.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-29.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface myReachability : NSObject
@property (strong, nonatomic) UILabel * blockLabel;
@property (assign, nonatomic) UILabel * notificationLabel;
-(void)reachabilityChanged:(NSNotification*)note;
-(void)myreachability:(UIView*)myview;
@end
