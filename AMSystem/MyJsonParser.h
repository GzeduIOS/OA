//
//  MyJsonParser.h
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-22.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyJsonParser : NSObject
+(NSMutableArray *)parseByArray:(NSDictionary *)dic;
+(NSMutableArray *)parseAttendByarr:(NSDictionary *)dic;
+(NSMutableArray *)parseAReportByarr:(NSDictionary *)dic;

@end
