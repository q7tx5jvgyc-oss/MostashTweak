#import <UIKit/UIKit.h>

static UIView *floatingButton;
static UIView *panel;

static void handleDrag(UIPanGestureRecognizer *pan) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [pan locationInView:window];
    floatingButton.center = point;
}

static void togglePanel() {
    panel.hidden = !panel.hidden;
}

static void closePanel() {
    panel.hidden = YES;
}

static void createFloatingButton() {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    floatingButton = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 60, 60)];
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

    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:nil action:@selector(togglePanel)];

    [floatingButton addGestureRecognizer:tap];

    [window addSubview:floatingButton];
}

static void createControlPanel() {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    panel = [[UIView alloc] initWithFrame:CGRectMake(50, 250, 250, 300)];
    panel.backgroundColor = [UIColor blackColor];
    panel.layer.cornerRadius = 15;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    title.text = @"Control Panel";
    title.textColor = UIColor.whiteColor;

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(80, 240, 100, 40);
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close addTarget:nil action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];

    [panel addSubview:title];
    [panel addSubview:close];

    panel.hidden = YES;

    [window addSubview:panel];
}

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)application {
    %orig;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{

        createFloatingButton();
        createControlPanel();
    });
}

%end
