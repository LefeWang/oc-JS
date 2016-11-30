//
//  ViewController.h
//  PracticeA
//
//  Created by Tesla on 2016/11/4.
//  Copyright © 2016年 Practice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"
#import "RequestModel.h"
@interface ViewController : UIViewController
@property(nonatomic,strong)LoginViewModel *loginviewModel;
@property(nonatomic,strong)RequestModel *requestModel;

@end

