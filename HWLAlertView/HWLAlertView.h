//
//  HWLAlertView.h
//  HWLAlertView
//
//  Created by 侯卫磊 on 16/8/17.
//  Copyright © 2016年 侯卫磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HWLAlertView;

typedef void(^ButtonBlock)(HWLAlertView * customAlertView,UIButton * button,NSInteger baseTag);


@interface HWLAlertView : UIView
@property (nonatomic,strong) NSArray * buttonTitles;
@property (nonatomic,copy) NSString * alertTitle;
@property (nonatomic,copy) NSString * alertMessage;

@property (nonatomic,copy) ButtonBlock buttonBlock;


- (void)show;

- (void)setButtonBlock:(ButtonBlock)buttonBlock;
@end
