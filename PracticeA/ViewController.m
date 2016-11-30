//
//  ViewController.m
//  PracticeA
//
//  Created by Tesla on 2016/11/4.
//  Copyright © 2016年 Practice. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
#import <AFHTTPSessionManager.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "TFHpple.h"




#import <CoreImage/CoreImage.h>
#import "GTMBase64.h"

@interface ViewController ()
{
    UITextField *nameTf;
    UITextField *pwdTf;
    UIButton *loginBtn;
    AFHTTPSessionManager *manager;
    UIWebView *webView;
    NSString * servertime;
    NSString * rsakv;
    NSString * nonce;
    NSString * showpin;
    NSString * pcid;
    
    NSString *userBase64;
    UIWebView *myWebView;
    
    
}

@end

@implementation ViewController

-(LoginViewModel *)loginviewModel
 {
     if (_loginviewModel==nil) {
         _loginviewModel=[[LoginViewModel alloc]init];
         
     }
     return _loginviewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    [self.requestModel.requestCommand execute:nil];
   
    [self setUpUI];
    
    
    @weakify(self);
    RAC(self.loginviewModel,name)=nameTf.rac_textSignal;
    RAC(self.loginviewModel,pwd)=pwdTf.rac_textSignal;
    RAC(loginBtn,enabled)=self.loginviewModel.enableLoginSIngnal;
    
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        
        NSLog(@"登录");
        
        [self loginRequest];
    }];
    

 }

-(void)setUpUI{
    nameTf=[[UITextField alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
    nameTf.placeholder=@"输入用户名";
    
    pwdTf=[[UITextField alloc]initWithFrame:CGRectMake(50, 180, 200, 50)];
    pwdTf.placeholder=@"请输入密码";
    
    loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, 250, 300, 50)];
    loginBtn.layer.cornerRadius=10.0;
    loginBtn.backgroundColor=[UIColor greenColor];
 
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    
    [self.view addSubview:nameTf];
    [self.view addSubview:pwdTf];
    [self.view addSubview:loginBtn];
}



//请求Sp
-(void)loginRequest{
    
    NSString *base64Str=[self encodeBase64String:nameTf.text ];
    userBase64 =base64Str;
    NSString *url=[NSString stringWithFormat:@"http://login.sina.com.cn/sso/prelogin.php?entry=weibo&callback=sinaSSOController.preloginCallBack&rsakt=mod&checkpin=1&client=ssologin.js(v1.4.5)&su=%@",base64Str];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
     
            NSLog(@"%@",data);
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
            
            NSRange startRange = [str rangeOfString:@"("];
            NSRange endRange = [str rangeOfString:@")"];
            
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
            NSString *result = [str substringWithRange:range];
            NSDictionary *dict=[self dictionaryWithJsonString:result];
            NSLog(@"%@",dict);
            /*
             servertime
             rsakv
             nonce
             showpin
             pcid
             
             */
            
            servertime =[dict objectForKey:@"servertime"];
            rsakv=[dict objectForKey:@"rsakv"];
            nonce=[dict objectForKey:@"nonce"];
            showpin =[dict objectForKey:@"showpin"];
            pcid =[dict objectForKey:@"pcid"];
            
          
            
            
            
            //取得sp
            NSString *sp=[self jsClick:nil];
            
            //请求登录
            dispatch_async(dispatch_get_main_queue(), ^{
                [self login:sp :nameTf.text];
            });
            
           
        }else{
        
            NSLog(@"cuowu %@",error.localizedDescription);
        }
    }];
  [dataTask resume];
}

//第二次请求登录
-(void)login :(NSString *)sp :(NSString *)userName{
    
    /*
     servertime
     rsakv
     nonce
     showpin
     pcid
     
     ('encoding=UTF-8');
     ('entry=weibo');
     ('from=');
     ('gateway=1');
     ('nonce='+ sNonce);
     ('pagerefer=');
     ('prelt=57');
     ('pwencode=rsa2');
     ('returntype=META');
     ('rsakv='+ sRsakv);
     ('savestate=7');
     ('servertime='+ sServertime);
     ('service=miniblog');
     //sp是上面算到的密码加密
     ('sp='+ sp);
     ('su='+ SinaUsername);
     ('url=http://weibo.com/ajaxlogin.php?framelogin=1&callback=parent.sinaSSOController.feedBackUrlCallBack');
     ('useticket=1');
     ('vsnf=1');

    */
    
NSDictionary *paramsDict=[[NSDictionary alloc]initWithObjectsAndKeys:@"UTF-8",@"encoding",
    @"weibo",@"entry",
    @"",@"from",
    @"1",@"gateway",
    nonce,@"sNonce",
    @"",@"pagerefer",
    @57,@"prelt",
    @"rsa2",@"pwencode",
    @"META",@"returntype",
    rsakv,@"rsakv",
    @7,@"savestate",
    servertime,@"servertime",
    @"miniblog",@"service",
    sp,@"sp",
    userName,@"su",
    @"http://weibo.com/ajaxlogin.php?framelogin=1&callback=parent.sinaSSOController.feedBackUrlCallBack",@"url",
    @1,@"useticket",
    @1,@"vsnf",
    nil];
    
    
    NSString *url=@"http://login.sina.com.cn/sso/login.php?client=ssologin.js(v1.4.5)";
    manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:url parameters:paramsDict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
//              TFHpple *doc=[[TFHpple alloc]initWithHTMLData:responseObject];
//              NSArray *elemts=[doc searchWithXPathQuery:@"java"];
              
              [responseObject writeToFile:@"/Users/TeslaMac/Desktop/PracticeA/PracticeA/secondget.html" options:NSDataWritingAtomic error:nil];
              
              
        NSLog(@"%@",responseObject);
              
          

       /*
        http://weibo.com/ajaxlogin.php?framelogin=1&callback=parent.sinaSSOController.feedBackUrlCallBack&retcode=20&reason=20&reason=%C7%EB%CA%E4%C8%EB%D5%FD%C8%B7%B5%C4%B5%C7%C2%BC%C3%FB
        
        */
     
              //第三次在主线程get请求
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self thirdGet];
              });
              
              
              
       /*
        http://weibo.com/ajaxlogin.php?framelogin=1&callback=parent.sinaSSOController.feedBackUrlCallBack&retcode=20&reason=20&reason=请输入正确的登录名
        */
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
    
    }




-(void)thirdGet{
    myWebView =[[UIWebView alloc]initWithFrame:CGRectMake(10, 64, 300, 500)];
    
    manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *url=@"http://weibo.com/ajaxlogin.php";
    NSString *url1=@"http://weibo.com/ajaxlogin.php?framelogin=1&callback=parent.sinaSSOController.feedBackUrlCallBack&retcode=20&reason=%C7%EB%CA%E4%C8%EB%D5%FD%C8%B7%B5%C4%B5%C7%C2%BC%C3%FB";
    
    [manager GET:url1 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [responseObject writeToFile:@"/Users/TeslaMac/Desktop/PracticeA/PracticeA/thirdget.html"options:NSDataWritingAtomic error:nil];
        
        
        
        
        
        
        
//        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
//        NSString *filePath =[resourcePath stringByAppendingPathComponent:@"thirdget.html"];
//        NSString *html=[[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//        
//        NSURL *url=[NSURL fileURLWithPath:@"/Users/TeslaMac/Desktop/PracticeA/PracticeA/thirdget.html"];
//        [myWebView loadHTMLString:html baseURL:url];
//        
//        [self.view addSubview:myWebView];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    




}






//调JS里面的方法
- (NSString *)jsClick :(NSArray *)array{
    
    JSContext *context = [[JSContext alloc] init];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SRSA" ofType:@"JS" ] encoding:NSUTF8StringEncoding error:nil];
    
    [context evaluateScript:str];
    NSArray *arr = [[NSArray alloc] initWithObjects:servertime,nonce,pwdTf.text, nil];
    
    JSValue *func = context[@"GetRSA"];
    NSString *string = [[func callWithArguments:arr] toString];
    return string;
}



//json 转字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


//加密
- (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
