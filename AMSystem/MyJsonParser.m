//
//  MyJsonParser.m
//  AMSystem
//
//  Created by 徐晓斐 on 14-9-22.
//  Copyright (c) 2014年 GZDEU. All rights reserved.
//

#import "MyJsonParser.h"
#import "PeoperData.h"
@implementation MyJsonParser

+(NSMutableArray *)parseByArray:(NSDictionary *)dic{
    
    NSMutableArray *Array = [NSMutableArray array];
    if (![[dic objectForKey:@"list"] isEqual:[NSNull null]]) {
        NSArray *list = [dic objectForKey:@"list"];
        for (NSDictionary *dic in list) {
            
            PeoperData *data = [[PeoperData alloc]init];
        
            if (![[dic objectForKey:@"LEAVE_NAME"] isEqual:[NSNull null]]) {
               data.name = [dic objectForKey:@"LEAVE_NAME"];
            }else{
               data.name = @"null";
            }
            //
            if (![[dic objectForKey:@"DEPT_NAME"] isEqual:[NSNull null]]) {
                data.deptName = [dic objectForKey:@"DEPT_NAME"];
            }else{
                data.deptName = @"null";
            }
            //
            if (![[dic objectForKey:@"APPLY_BEGIN_DATE"] isEqual:[NSNull null]]) {
                data.applyBeginDate = [dic objectForKey:@"APPLY_BEGIN_DATE"];
            }else{
                data.applyBeginDate = @"null";
            }
            //
            if (![[dic objectForKey:@"APPLY_END_DATE"] isEqual:[NSNull null]]) {
                data.applyEndDate = [dic objectForKey:@"APPLY_END_DATE"];
            }else{
                data.applyEndDate = @"null";
            }
            //
            if (![[dic objectForKey:@"APPLY_TYPE"] isEqual:[NSNull null]]) {
                data.applyType = [dic objectForKey:@"APPLY_TYPE"];
            }else{
                data.applyType = @"null";
            }
            //
            if (![[dic objectForKey:@"APPLY_REASON"] isEqual:[NSNull null]]) {
                data.applyReason = [dic objectForKey:@"APPLY_REASON"];
            }else{
                data.applyReason = @"null";
            }
            //
            if (![[dic objectForKey:@"APPLY_TIME_SPAN"] isEqual:[NSNull null]]) {
                data.applyTimeSpan = [dic objectForKey:@"APPLY_TIME_SPAN"];
            }else{
                data.applyTimeSpan = @"null";
            }
            //
            if (![[dic objectForKey:@"LEAVE_APPLY_ID"] isEqual:[NSNull null]]) {
                data.leaveId = [dic objectForKey:@"LEAVE_APPLY_ID"];
            }
            
            [Array addObject:data];
        }
        
    }
    return Array;
}
+(NSMutableArray *)parseAttendByarr:(NSDictionary *)dic{
    
    NSMutableArray *arraydic = [NSMutableArray array];
    if (![[dic objectForKey:@"list"] isEqual:[NSNull null]]) {
        
        NSArray *arr = [dic objectForKey:@"list"];
        for (NSDictionary *dic in arr) {
            
            PeoperData *user = [[PeoperData alloc]init];
            if (![[dic objectForKey:@"NAME"] isEqual:[NSNull null]]) {
                user.attname = [dic objectForKey:@"NAME"];
                
            }else{
                user.attname = @"null";
                
            }
            
            if (![[dic objectForKey:@"DEPT_NAME"] isEqual:[NSNull null]]) {
                user.deptname = [dic objectForKey:@"DEPT_NAME"];
                
            }else{
                user.deptname = @"null";
                
            }
            if (![[dic objectForKey:@"SIGN_ADDRESS"] isEqual:[NSNull null]]) {
                user.signaddres = [dic objectForKey:@"SIGN_ADDRESS"];
                
            }else{
                user.signaddres = @"null";
                
            }
            if (![[dic objectForKey:@"SIGN_DATE"] isEqual:[NSNull null]]) {
                user.signdate = [dic objectForKey:@"SIGN_DATE"];
                
            }else{
                user.signdate = @"null";
                
            }
            if (![[dic objectForKey:@"SIGN_TYPE"] isEqual:[NSNull null]]) {
                user.signtype = [dic objectForKey:@"SIGN_TYPE"];
                
            }else{
                user.signtype = @"null";
                
            }
            
            if (![[dic objectForKey:@"ATTENDANCE_ID"] isEqual:[NSNull null]]) {
                user.attendanceId = [dic objectForKey:@"ATTENDANCE_ID"];
                
            }else{
                user.attendanceId = @"null";
                
            }
            if (![[dic objectForKey:@"SIGN_TYPE"] isEqual:[NSNull null]]) {
                user.signtype = [dic objectForKey:@"SIGN_TYPE"];
                
            }else{
                user.signtype = @"null";
                
            }
            
            if (![[dic objectForKey:@"PIC"] isEqual:[NSNull null]]) {
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"PIC"]]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    UIImage *img = [UIImage imageWithData:data];
                    img = [MyJsonParser imageWithMaxSide:30 sourceImage:img];
                    user.pic = img;
                });
            }
            
            [arraydic addObject:user];
            
        }
    }
    return arraydic;
}
+(NSMutableArray *)parseAReportByarr:(NSDictionary *)dic{
    
    NSArray *list = [dic objectForKey:@"list"];
    NSMutableArray *AReportDic = [NSMutableArray array];
    
    for (NSDictionary *dic in list) {
        
        PeoperData *p = [[PeoperData alloc]init];
        if (![[dic objectForKey:@"NAME"] isEqual:[NSNull null]]) {
            p.AReportname = [dic objectForKey:@"NAME"];
            
        }else{
            p.AReportname = @"null";
            
        }
        if (![[dic objectForKey:@"NORMAL_NUM"] isEqual:[NSNull null]]) {
            p.normal_num = [dic objectForKey:@"NORMAL_NUM"];
            
        }else{
            p.normal_num = @"null";
            
        }
        
        if (![[dic objectForKey:@"EXCEPTION_NUM"] isEqual:[NSNull null]]) {
           p.exception_num = [dic objectForKey:@"EXCEPTION_NUM"];
        }else{
            p.exception_num = @"null";
            
        }

        [AReportDic addObject:p];
    
    }
    
    return AReportDic;
}

+ (UIImage *)imageWithMaxSide:(CGFloat)length sourceImage:(UIImage *)image{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize imgSize = CWSizeReduce(image.size, length);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, scale);// 创建一个 bitmap context
    
    [image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)
            blendMode:kCGBlendModeNormal alpha:1.0];// 将图片绘制到当前的 context 上
    
    img = UIGraphicsGetImageFromCurrentImageContext();// 从当前 context 中获取刚绘制的图片
    UIGraphicsEndImageContext();
    
    return img;
}

static inline CGSize CWSizeReduce(CGSize size, CGFloat limit)// 按比例减少尺寸
{
    CGFloat max = MAX(size.width, size.height);
    if (max < limit) {
        return size;
    }
    
    CGSize imgSize;
    CGFloat ratio = size.height / size.width;
    
    if (size.width > size.height) {
        imgSize = CGSizeMake(limit, limit*ratio);
    } else {
        imgSize = CGSizeMake(limit/ratio, limit);
    }
    
    return imgSize;
}
@end
