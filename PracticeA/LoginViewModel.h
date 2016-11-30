//
//  LoginViewModel.h
//  PracticeA
//
//  Created by Tesla on 2016/11/17.
//  Copyright © 2016年 Practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface LoginViewModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *pwd;
@property(nonatomic,strong,readonly)RACSignal *enableLoginSIngnal;
@property(nonatomic,strong,readonly)RACCommand *loginCommand;

@end
