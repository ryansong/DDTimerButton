//
//  DDTimerButton.h
//  DDTimerButton
//
//  Created by xiaomingsong on 11/8/15.
//  Copyright © 2015 xiaomingsong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^HandleClickButton)(void);
typedef void (^HandleTimeOver)(void);

@interface DDTimerButton : UIButton

@property (nonatomic, assign) NSUInteger timerInterval;

@property (nonatomic, copy) HandleClickButton sendVerifyCodeBlock;
@property (nonatomic, copy) HandleTimeOver finishVerifyBlock;

- (instancetype)initWithInterval:(NSUInteger)seconds title:(NSString *)title;
- (instancetype)initWithInterval:(NSUInteger)seconds title:(NSString *)title withIdentifier:(NSString *) identifier;

@end

