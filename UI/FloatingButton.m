#import <UIKit/UIKit.h>

UIView *floatingButton;
UIView *panel;

void createFloatingButton() {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    floatingButton = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 60, 60)];
    floatingButton.backgroundColor = [UIColor systemBlueColor];
    floatingButton.layer.cornerRadius = 30;

    UILabel *label = [[UILabel alloc] initWithFrame:floatingButton.bounds];
    label.text = @"M";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;

    [floatingButton addSubview:label];

    UIPanGestureRecognizer *drag =
        [[UIPanGestureRecognizer alloc] initWithTarget:nil action:@selector(handleDrag:)];

    [floatingButton addGestureRecognizer:drag];

    [window addSubview:floatingButton];
}

void handleDrag(UIPanGestureRecognizer *pan) {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [pan locationInView:window];

    floatingButton.center = point;
}
