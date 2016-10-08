//
//  DDTimerButton.m
//  DDTimerButton
//
//  Created by xiaomingsong on 11/8/15.
//  Copyright © 2015 xiaomingsong. All rights reserved.
//

#import "DDTimerButton.h"

static NSString *const USERDEFAULT_TIMER_INDENTIFIER_KEY = @"kUserDefaultDDTimerIdentifiersKey";

static NSString *const  progressTitleFormat = @"%d 秒";

@interface DDTimerButton () {
    dispatch_source_t timer;
}

@property (nonatomic, assign) NSTimeInterval expiredTime;
@property (nonatomic, copy) NSString * titleFormat;
@property (nonatomic, copy) NSString * buttonIdentifier;


@property (nonatomic, strong) NSMutableDictionary *identifierDict;

@end

@implementation DDTimerButton

- (void)dealloc
{
    if (timer) {
        dispatch_source_cancel(timer);
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }

    return self;
}
- (instancetype)initWithInterval:(NSUInteger)seconds title:(NSString *)title {
    self = [self initWithInterval:(NSUInteger)seconds title:(NSString *)title withIdentifier:nil];
    return self;
}

- (instancetype)initWithInterval:(NSUInteger)seconds title:(NSString *)title withIdentifier:(NSString *) identifier {
    self = [super init];
    
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        _timerInterval = seconds;
        _buttonIdentifier = identifier;
        
        if ([self hasRegisterIdentifier:identifier]) {
            [self startCounting];
        }
    }
    
    return self;
}


+ (instancetype)sharedButton {
    static DDTimerButton *sharedButton;
    
    dispatch_once_t onece;
    dispatch_once(&onece, ^{
        sharedButton = [[DDTimerButton alloc] init];
    });
    
    return sharedButton;
}


- (void)startCounting {
    if ([self hasRegisterIdentifier:_buttonIdentifier]) {
        self.expiredTime = [self expiredTimeWithRegisterIdentifier:_buttonIdentifier];
    } else {
        _expiredTime = [self expiredTimeInterval];
        [self registerIdentifier:_buttonIdentifier expiredTime:_expiredTime];
    }
    
    __weak DDTimerButton *weakSelf = self;
    
    NSTimeInterval expiredTime = _expiredTime;
    CGFloat reSecond = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, reSecond * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{

        __strong DDTimerButton *strongSelf = weakSelf;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        NSInteger secondsRemain = round(expiredTime - now);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf setTitle:[NSString stringWithFormat:weakSelf.titleFormat, secondsRemain] forState:UIControlStateNormal];
        });
        
        if (secondsRemain <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.enabled = YES;
                [strongSelf resignIdentifier:weakSelf.buttonIdentifier];
                if (strongSelf.finishVerifyBlock) {
                    strongSelf.finishVerifyBlock();
                }
            });
            
        }
    });
    dispatch_resume(timer);
}

#pragma mark - Action

- (void)clickButtonAction:(id)sender {
    if (self.sendVerifyCodeBlock) {
        self.enabled = NO;
        BOOL sendCodeSuccess = self.sendVerifyCodeBlock();
        if (sendCodeSuccess) {
            
            [self startCounting];
        } else {
            self.enabled = YES;
        }
        
    }
}

- (void)setSendVerifyCodeBlock:(HandleClickButton)theSendVerifyCodeBlock {
    _sendVerifyCodeBlock = theSendVerifyCodeBlock;
    [self addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - private

- (NSTimeInterval)expiredTimeInterval{
    return [[NSDate date] timeIntervalSince1970] + self.timerInterval;
}

- (BOOL)hasRegisterIdentifier:(NSString *)identifer{
    if (!identifer) {
        return NO;
    }
    
    if ([self.identifierDict objectForKey:identifer]) {
        return YES;
    };

    return NO;
}

- (NSTimeInterval)expiredTimeWithRegisterIdentifier:(NSString *)identifer{
    if (!identifer) {
        return NO;
    }
    
    NSNumber *expiredTime = [self.identifierDict objectForKey:identifer];
    if (expiredTime) {
        return expiredTime.doubleValue;
    };
    
    return 0;
}

- (void)registerIdentifier:(NSString *)identifer expiredTime:(NSUInteger)expiredTime
{
    if (!identifer) {
        return;
    }
    
    [self.identifierDict setObject:@(expiredTime) forKey:identifer];
    [[NSUserDefaults standardUserDefaults] setObject:self.identifierDict forKey:USERDEFAULT_TIMER_INDENTIFIER_KEY];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resignIdentifier:(NSString *)identifer
{
    if (!identifer) {
        return;
    }
    
    self.identifierDict = [[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_TIMER_INDENTIFIER_KEY] mutableCopy];
    
    [self.identifierDict removeObjectForKey:identifer];
    [[NSUserDefaults standardUserDefaults] setObject:self.identifierDict forKey:USERDEFAULT_TIMER_INDENTIFIER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - getter

- (NSString *)titleFormat {

    if (!_titleFormat) {
        _titleFormat = progressTitleFormat;
    }
    
    return _titleFormat;
}

- (NSMutableDictionary *)identifierDict
{
    if (!_identifierDict) {
        _identifierDict = [[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULT_TIMER_INDENTIFIER_KEY] mutableCopy];
        
        if (!_identifierDict) {
            _identifierDict = [NSMutableDictionary dictionary];
        }
    }
    return _identifierDict;
}

@end
