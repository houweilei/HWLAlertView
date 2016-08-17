//
//  HWLAlertView.m
//  HWLAlertView
//
//  Created by 侯卫磊 on 16/8/17.
//  Copyright © 2016年 侯卫磊. All rights reserved.
//

#import "HWLAlertView.h"

#define kScreenSize [UIScreen mainScreen].bounds.size


static CGFloat contentViewWidth = 260.0f;
static CGFloat contentViewHeight = 150.0f;
static CGFloat buttonVerticalTopSpace = 10;
static CGFloat buttonVerticalBottomSpace = 10;

static CGFloat buttonHeight = 36.0f;
static NSInteger buttonBaseTag = 100;

@interface HWLAlertView ()
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * messageLabel;

@property (nonatomic,strong) UIView * buttonBackgroundView;
@end

@implementation HWLAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        self.alpha = 0.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 10.0f;
        [self createBlurBackgroundView];
        [self addSubview:self.contentView];
        [self addTitlelabelAndMessageLabel];
    }
    
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 1.0f;
    }];
    [[self rootView] addSubview:self];
}

#pragma mark - 按钮点击事件
- (void)clickButton:(UIButton *)button {
    if (self.buttonBlock) {
        self.buttonBlock(self,button,buttonBaseTag);
    }
    
    [self removeFromSuperview];
}

- (void)tapEffectView:(UITapGestureRecognizer *)gesture {
    [self removeFromSuperview];
}

#pragma mark - 创建所需视图
- (void)addTitlelabelAndMessageLabel {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageLabel];
}

- (void)createBlurBackgroundView {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    view.backgroundColor = [UIColor colorWithRed:241/255.0f green:236/255.0f blue:228/255.0f alpha:0.7f];
    [self addSubview:view];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEffectView:)];
    [self addGestureRecognizer:tap];
}

- (void)createButtonWithTitles:(NSArray <NSString *> *)titles {
    CGFloat buttonSpace = 20.0f;
    CGFloat buttonWidth = (contentViewWidth - buttonSpace * (titles.count + 1))/titles.count;
    
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton * button = [self buttonWithFrame:CGRectMake(buttonSpace + (buttonSpace + buttonWidth) * i, 0, buttonWidth, buttonHeight) backgroundColor:[UIColor colorWithRed:181/255.0f green:155/255.0f blue:127/255.0f alpha:0.08f] titleColor:[UIColor blackColor] tag:buttonBaseTag + i];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [self.buttonBackgroundView addSubview:button];
    }
    
    [self.contentView addSubview:self.buttonBackgroundView];
}

#pragma mark - 懒加载
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [self viewWithFrame:CGRectMake((kScreenSize.width - contentViewWidth)/2.0f, (kScreenSize.height - contentViewHeight)/2.0f, contentViewWidth, contentViewHeight) backgroundColor:[UIColor colorWithRed:254/255.0 green:253/255.0f blue:252/255.0f alpha:1.0f]];
    }
    
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self labelWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 50) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17.0f]];
    }
    
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [self labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.contentView.bounds), contentViewHeight - CGRectGetHeight(self.titleLabel.bounds) - buttonHeight - buttonVerticalTopSpace) backgroundColor:[UIColor clearColor] textColor:[UIColor colorWithRed:165/255.0f green:142/255.0f blue:118/255.0f alpha:1.0f] font:[UIFont systemFontOfSize:14.0f]];
    }
    
    return _messageLabel;
}

- (UIView *)buttonBackgroundView {
    if (!_buttonBackgroundView) {
        _buttonBackgroundView = [self viewWithFrame:CGRectMake(0, contentViewHeight - buttonHeight - buttonVerticalBottomSpace, contentViewWidth, buttonHeight) backgroundColor:[UIColor clearColor]];
    }
    
    return _buttonBackgroundView;
}
#pragma mark - settr && getter
- (void)setButtonTitles:(NSArray *)buttonTitles {
    if (buttonTitles.count) {
        [self createButtonWithTitles:buttonTitles];
        
    }
}

- (void)setAlertTitle:(NSString *)alertTitle {
    self.titleLabel.text = alertTitle;
}

- (void)setAlertMessage:(NSString *)alertMessage {
    self.messageLabel.text = alertMessage;
}

#pragma mark - 调整布局
- (void)resetSubviewsFrame {
    if (!self.titleLabel.text) {
        [self.titleLabel removeFromSuperview];
        self.messageLabel.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight - buttonHeight - buttonVerticalTopSpace);
        
    }
    
    if (!self.messageLabel.text) {
        [self.messageLabel removeFromSuperview];
        self.titleLabel.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight - buttonHeight - buttonVerticalTopSpace);
    } else {
        
        [self.messageLabel sizeToFit];
        if (self.messageLabel.bounds.size.width <= contentViewWidth) {
            self.messageLabel.frame = CGRectMake(0, CGRectGetHeight(self.titleLabel.bounds), contentViewWidth, self.messageLabel.bounds.size.height);
        }
    }
    
    if (self.messageLabel.text) {
        self.contentView.frame = CGRectMake((kScreenSize.width - contentViewWidth)/2.0f, (kScreenSize.height - (CGRectGetHeight(self.titleLabel.bounds) + CGRectGetHeight(self.messageLabel.bounds) + buttonHeight + buttonVerticalTopSpace + buttonVerticalBottomSpace))/2.0f, contentViewWidth, CGRectGetHeight(self.titleLabel.bounds) + CGRectGetHeight(self.messageLabel.bounds) + buttonHeight + buttonVerticalTopSpace + buttonVerticalBottomSpace) ;
        
    } else {
        self.contentView.frame = CGRectMake((kScreenSize.width - contentViewWidth)/2.0f, (kScreenSize.height - (CGRectGetHeight(self.titleLabel.bounds) + buttonHeight + buttonVerticalTopSpace + buttonVerticalBottomSpace))/2.0f, contentViewWidth, CGRectGetHeight(self.titleLabel.bounds) + buttonHeight + buttonVerticalTopSpace + buttonVerticalBottomSpace) ;
        
    }
    self.buttonBackgroundView.frame = CGRectMake(0, CGRectGetMaxY(self.messageLabel.frame) + buttonVerticalTopSpace, contentViewWidth, buttonHeight);
}
#pragma mark - 获取应用的根视图
- (UIView *)rootView {
    [self resetSubviewsFrame];
    return [[self rootViewController] view];
}

- (UIViewController *)rootViewController {
    UIApplication * application = [UIApplication sharedApplication];
    UIWindow * keyWindow = application.keyWindow;
    UIViewController * viewController = keyWindow.rootViewController;
    
    return viewController;
}

#pragma mark - 控件创建方法
- (UIButton *)buttonWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor tag:(NSInteger)tag {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = backgroundColor;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.tag = tag;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = frame.size.height/2.0f;
    return button;
}

- (UILabel *)labelWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backgroundColor;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

- (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor {
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    
    return view;
}

@end
