//
//  FBYImageZoom.m
//  FBYImageZoom-iOS
//
//  Created by fby on 2018/3/2.
//  Copyright © 2018年 FBYImageZoom-iOS. All rights reserved.
//

#import "FBYImageZoom.h"

@implementation FBYImageZoom

static CGRect oldframe;

+(void)scanBigImageWithImage:(UIImage *)image frame:(CGRect)pOldframe {
    oldframe = pOldframe;
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [backgroundView setBackgroundColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:99/255.0 alpha:0.6]];
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.userInteractionEnabled = YES;
    [imageView setImage:image];
    [imageView setTag:1024];
    [backgroundView addSubview:imageView];
    //将原始视图添加到背景视图中
    [window addSubview:backgroundView];
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //捏合
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [backgroundView addGestureRecognizer:pinch];
    
    
    //创建一个拖动手势
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
    //给图片添加手势
    [imageView addGestureRecognizer:pan];
    //动画放大所展示的ImageView
    
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        //宽度为屏幕宽度
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  @param contentImageview 图片所在的imageView
 */

+(void)ImageZoomWithImageView:(UIImageView *)contentImageview{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self scanBigImageWithImage:contentImageview.image frame:[contentImageview convertRect:contentImageview.bounds toView:window]];
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
+(void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:1024];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}


+ (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    CGFloat scale = recognizer.scale;
    //原始imageview
    UIImageView *imageView = [recognizer.view viewWithTag:1024];
    //放大情况
    
    imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale);
    recognizer.scale = 1.0;
    
}

+(void)drag:(UIPanGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"FlyElephant---视图拖动开始");
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [recognizer locationInView:recognizer.view.superview];
        //可以允许移动出屏幕
//        if (location.y < 0 || location.y > self.view.bounds.size.height) {
//            return;
//        }
        CGPoint translation = [recognizer translationInView:recognizer.view.superview];
        
        NSLog(@"当前视图在View的位置:%@----平移位置:%@",NSStringFromCGPoint(location),NSStringFromCGPoint(translation));
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"FlyElephant---视图拖动结束");
    }
}


@end
