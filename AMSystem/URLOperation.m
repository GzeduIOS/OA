//
//  URLOperation.m
//  AMSystem
//
//  Created by Benjamin on 11/7/14.
//  Copyright (c) 2014 GZDEU. All rights reserved.
//

#import "URLOperation.h"
#import "SBJson/JSON.h"
#import "PeoperData.h"
#import "MyCell.h"

@interface URLOperation()

//分隔符(下横线开头后随意字符)
@property NSString *boundary;
//分界线 --AaB03x
@property NSString *startBoundary;
//结束符 AaB03x--
@property NSString *endBoundary;
//换行符
@property NSString *returnFlag;
//请求内容
@property NSMutableData *body;
//图片数据集合
@property NSMutableDictionary *images;

@end


@implementation URLOperation

static NSString *IMAGE_FLAG = @"imageFlag";

@synthesize boundary;
@synthesize startBoundary;
@synthesize endBoundary;
@synthesize returnFlag;
@synthesize body;
@synthesize images;

-(BOOL)isConcurrent {
  return YES;//返回yes表示支持异步调用，否则为支持同步调用
}
- (BOOL)isExecuting {
    return executing;
}
- (BOOL)isFinished {
    return finished;
}

- (void)start {
    if ([self isCancelled]){ return; }
    
    executing = YES;
    
    
    
    //回调代码块
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSString *dataString = [[NSString alloc]initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
        NSDictionary *json = [jsonParser objectWithString:dataString error:nil];
        
        if ([delegate respondsToSelector:@selector(connectionFinishWithJson:)]) {
            // 把数据传回到主线程
            [(NSObject *)delegate performSelectorOnMainThread:@selector(connectionFinishWithJson:) withObject:json waitUntilDone:NO];
        }
    }];
    
    finished = YES;
}


-(id)initURLWithString:(NSString *)url
         andWithParams:(NSMutableDictionary *)params
              delegate:(id<URLOperationDelegate>)dele{
    
    if (self = [super init]) {
        executing = NO;
        finished = NO;

        delegate = dele;
        
        //中文编码
        //encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //通用编码
        encoding = NSUTF8StringEncoding;
        
        boundary = @"AaB03x";
        startBoundary = [[NSString alloc]initWithFormat:@"--%@",boundary];
        endBoundary = [[NSString alloc]initWithFormat:@"%@--",startBoundary];
        returnFlag=@"/r/n";
        
        
        urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        urlRequest.HTTPMethod = @"POST";
        [urlRequest addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
        
        body = [[NSMutableData alloc]init];
        urlParams = params;
        
        
    }
    return self;
}

-(void) processBodyWithParams:(NSDictionary *)params{
    
    //设置URL参数
    NSArray *keys= [params allKeys];
    for(int i=0;i<[keys count];i++){//遍历keys
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //处理图片数据
        if([key isEqualToString:IMAGE_FLAG]){
            [self processBodyImages:[params objectForKey:key]];
        }else{
            [self processBodyParamByName:key andValue:[params objectForKey:key]];
        }
        
    }
    
    //设置结束符
    [body appendData:[[NSString stringWithFormat:@"%@", endBoundary] dataUsingEncoding:encoding]];
    
    //设置内容长度
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    urlRequest.HTTPBody = body;//赋值
}

-(void) processBodyParamByName:(NSString *)name andValue:(NSString *)value{
    //添加分界线，换行
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", startBoundary] dataUsingEncoding:encoding]];
    //添加字段名称，换2行
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name] dataUsingEncoding:encoding]];
    //添加字段的值
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", value] dataUsingEncoding:encoding]];
}

-(void) processBodyImages:(NSMutableDictionary *)imagesDictionary{
    
    NSArray *imagekeys= [imagesDictionary allKeys];
    for(int i=0;i<[imagekeys count];i++){//遍历keys
        //得到当前key
        NSString *imagekey=[imagekeys objectAtIndex:i];
        //设置图片
        NSString *interfacePicParamName = @"file_arr";
        NSString *uploadPicName = [NSString stringWithFormat:@"%@.png", imagekey];//上传图片名称
        NSData *picData = [imagesDictionary objectForKey:imagekey];
        if (picData) {
            //添加分界线，换行
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", startBoundary] dataUsingEncoding:encoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", interfacePicParamName, uploadPicName] dataUsingEncoding:encoding]];
            [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:encoding]];
            [body appendData:picData];//插入大数据(图片)
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
}



@end

