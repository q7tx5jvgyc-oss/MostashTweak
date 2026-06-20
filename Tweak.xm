#import <UIKit/UIKit.h>

static UIView *floatingButton;
static UIView *panel;
static BOOL panelVisible = NO;

#pragma mark - ===== Window Helper (FIXED iOS 15+) =====

static UIWindow *getKeyWindow() {

    UIWindow *keyWindow = nil;

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {

        if (scene.activationState != UISceneActivationStateForegroundActive)
            continue;

        if (![scene isKindOfClass:[UIWindowScene class]])
            continue;

        UIWindowScene *ws = (UIWindowScene *)scene;

        for (UIWindow *w in ws.windows) {
            if (w.isKeyWindow) {
                keyWindow = w;
                break;
            }
        }

        if (keyWindow) break;
    }

    return keyWindow;
}

#pragma mark - ===== Floating Button =====

static void handleDrag(UIPanGestureRecognizer *pan) {
    UIWindow *window = getKeyWindow();
    CGPoint point = [pan locationInView:window];
    floatingButton.center = point;
}

static void togglePanel() {
    panelVisible = !panelVisible;
    panel.hidden = !panelVisible;
}

static void createFloatingButton() {

    UIWindow *window = getKeyWindow();

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

#pragma mark - ===== Control Panel =====

static void createControlPanel() {

    UIWindow *window = getKeyWindow();

    panel = [[UIView alloc] initWithFrame:CGRectMake(50, 250, 260, 300)];
    panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
    panel.layer.cornerRadius = 15;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    title.text = @"MOSTASH PANEL";
    title.textColor = UIColor.whiteColor;

    UIButton *speedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    speedBtn.frame = CGRectMake(20, 80, 200, 40);
    [speedBtn setTitle:@"Speed x2" forState:UIControlStateNormal];

    [speedBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"Speed activated");
    }] forControlEvents:UIControlEventTouchUpInside];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(80, 240, 100, 40);
    [close setTitle:@"Close" forState:UIControlStateNormal];

    [close addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        panel.hidden = YES;
        panelVisible = NO;
    }] forControlEvents:UIControlEventTouchUpInside];

    [panel addSubview:title];
    [panel addSubview:speedBtn];
    [panel addSubview:close];

    panel.hidden = YES;

    [window addSubview:panel];
}

#pragma mark - ===== Hook =====

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
