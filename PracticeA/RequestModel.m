//
//  RequestModel.m
//  PracticeA
//
//  Created by Tesla on 2016/11/17.
//  Copyright © 2016年 Practice. All rights reserved.
//

#import "RequestModel.h"

#import <MJExtension/MJExtension.h>

@implementation RequestModel
{
    AFHTTPSessionManager *manager;

}

-(instancetype)init{
    if (self=[super init]) {
//        [self initialBind];
    }
    return self;

}
//-(void)initialBind{
//  _requestCommand=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
//   RACSignal *dataSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//       manager=[AFHTTPSessionManager manager];
//          NSMutableDictionary *params=[NSMutableDictionary new];
//          params[@"q"]=@"美女大学生";
//         
//          [manager GET:@"https://api.douban.com/v2/book/search" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//             float num= 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//              NSLog(@"%lf",num);
//          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//              
//              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                  [subscriber sendNext:responseObject];
//              
//                  [responseObject writeToFile:@"/Users/TeslaMac/Desktop/PracticeA/PracticeA/myinfo.plist" atomically:YES];
//                 
//              });
//               [subscriber sendCompleted];
//          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              NSLog(@"shibai");
//          }];
//          
//          return nil;
//
//      }];
//      return [dataSignal map:^id(NSDictionary * value) {
//          NSMutableArray *dictaRR=[NSMutableArray new];
//          dictaRR=[value objectForKey:@"books"];
//          
//         
//
//    
//
//}
//    }
//              }
@end
