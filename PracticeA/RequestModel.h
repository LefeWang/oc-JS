//
//  RequestModel.h
//  PracticeA
//
//  Created by Tesla on 2016/11/17.
//  Copyright © 2016年 Practice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import <AFHTTPSessionManager.h>
@interface RequestModel : NSObject
@property(nonatomic,strong,readonly)RACCommand *requestCommand;
@property(nonatomic,strong,readonly)NSArray *modelArr;
@property(nonatomic,weak)UITableView *tableview;
@end
