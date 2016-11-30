//
//  LoginViewModel.m
//  PracticeA
//
//  Created by Tesla on 2016/11/17.
//  Copyright © 2016年 Practice. All rights reserved.
//

#import "LoginViewModel.h"
#import <MBProgressHUD.h>
#import <AFHTTPSessionManager.h>
#import "GTMBase64.h"


@implementation LoginViewModel
{
    AFHTTPSessionManager *manager;

}
-(instancetype)init{
    if (self=[super init]) {
        [self initBind];
    }
    return self;
}

//+ (LoginViewModel *)sharedClient {
//    static LoginViewModel *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSURL *baseURL = [NSURL URLWithString:@""];
//        
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"TuneStore iOS 1.0"}];
//        
//        
//        //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
//        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
//    diskCapacity:50 * 1024 * 1024
//    diskPath:nil];
//        
//        [config setURLCache:cache];
//     });
//    return _sharedClient;
//}

- (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}



-(void)initBind{
   
    _enableLoginSIngnal=[RACSignal combineLatest:@[RACObserve(self,name),RACObserve(self, pwd)] reduce:^id(NSString *name,NSString *pwd){
        
        return @(name.length>3&&pwd.length);
       
    }];
    
    
    _loginCommand=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"点击登录");
        RACSignal *dataSignal= [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            manager=[AFHTTPSessionManager manager];
                    
            NSString *base64Str=[self encodeBase64String:_name];
          
            NSString *url=[NSString stringWithFormat:@"http://login.sina.com.cn/sso/prelogin.php?entry=weibo&callback=sinaSSOController.preloginCallBack&rsakt=mod&checkpin=1&client=ssologin.js(v1.4.5)&su=%@",base64Str];
            NSLog(@"%@",base64Str);
            
            
            [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                         float num= 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                          NSLog(@"%lf",num);
                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                              [subscriber sendNext:responseObject];
            
                              [responseObject writeToFile:@"/Users/TeslaMac/Desktop/PracticeA/PracticeA/myinfo.plist" atomically:YES];
            
                          });
                           [subscriber sendCompleted];
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"shibai");
                      }];
             return nil;
        }];
      return [dataSignal map:^id(NSDictionary * value) {
                      NSMutableArray *dictaRR=[NSMutableArray new];
                      dictaRR=[value objectForKey:@"books"];
          return dictaRR;
          }];
        
    }];


  [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
      if ([x isEqualToString:@"success"]) {
          NSLog(@"success");
      }
  }];
    
  
    
//    _loginCommand=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
//       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//           [subscriber sendNext:@"请求的数据"];
//           [subscriber sendCompleted];
//           return nil;
//       }];
//        
//    }];
//    
    
    [self.loginCommand execute:@"2"];
    
    
  
    //处理登录返回的结果
    
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    //处理登录执行过程
//    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
//        if ([x boolValue]==YES) {
//            NSLog(@"zhenzaizhix ");
//            
//            //
//        }else{
//        
//        
//        }
//    }];
    
    

}



@end
