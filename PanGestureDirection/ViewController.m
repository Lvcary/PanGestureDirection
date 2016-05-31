//
//  ViewController.m
//  PanGestureDirection
//
//  Created by 刘康蕤 on 16/5/31.
//  Copyright © 2016年 刘康蕤. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    
    LKPanDirectionNone,  // 无法识别方向
    LKPanDirectionUp,    // 向上拖动
    LKPanDirectionDown,  // 向下拖动
    LKPanDirectionLeft,  // 向左拖动
    LKPanDirectionRight, // 向右拖动
    
}LKPanDirection;

CGFloat const minimumTranslation = 20.0;

@interface ViewController ()

@property (nonatomic ,assign) LKPanDirection direction;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    /**
     根据pan手势的偏移判断手势的方向，实用情况 一个scrollView上放多个tableview 判断是左右滑还是上下滑等。
     */
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:pan];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 100, 100, 200, 60)];
    label.text = @"手指滑上来试试，看看控制台输出";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
}

- (void)panGestureAction:(UIPanGestureRecognizer *)sender {

    CGPoint point = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _direction = LKPanDirectionNone;
    }
    else if (sender.state == UIGestureRecognizerStateChanged && _direction == LKPanDirectionNone) {
        _direction = [self directionByPoint:point];
        switch (_direction) {
            case LKPanDirectionUp:
                NSLog(@"Direction up");
                break;
            case LKPanDirectionDown:
                NSLog(@"Direction down");
                break;
            case LKPanDirectionLeft:
                NSLog(@"Direction left");
                break;
            case LKPanDirectionRight:
                NSLog(@"Direction right");
                break;
                
            default:
//                NSLog(@"none");
                break;
        }
    }else if(sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"stop");
    }
    
}

// 根据手势位移判断方向
- (LKPanDirection )directionByPoint:(CGPoint)translation {
    if (_direction != LKPanDirectionNone) {
        return _direction;
    }
    // 取绝对值
    if (fabs(translation.x) > minimumTranslation) {
        
        BOOL gestureHorizontal = NO;
        if (translation.y == 0) {
            gestureHorizontal = YES;
        }else {
            gestureHorizontal = (fabs(translation.x / translation.y) > 2.0);
        }
        if (gestureHorizontal) {
            if (translation.x > 0) {
                return LKPanDirectionRight;
            }else {
                return LKPanDirectionLeft;
            }
        }
        
    }else if(fabs(translation.y) > minimumTranslation) {
        
        BOOL gesturnVertical = NO;
        if (translation.x == 0) {
            gesturnVertical = YES;
        }else {
            gesturnVertical = (fabs(translation.y / translation.x) > 2.0);
        }
        if (gesturnVertical) {
            if (translation.y > 0) {
                return LKPanDirectionDown;
            }else {
                return LKPanDirectionUp;
            }
        }
        
    }
    
    return _direction;
}

@end
