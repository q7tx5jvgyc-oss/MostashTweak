#import <UIKit/UIKit.h>

static UIView *floatingButton;
static UIView *panel;
static BOOL panelVisible = NO;

#pragma mark - ===== نظام التحقق =====

static BOOL isActivated() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"MOSTASH_ACTIVATED"];
}

static void saveActivation() {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MOSTASH_ACTIVATED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

static void showActivationAlert(UIWindow *window) {

    UIView *bg = [[UIView alloc] initWithFrame:window.bounds];
    bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    bg.tag = 999;

    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(40, 200, window.frame.size.width - 80, 220)];
    box.backgroundColor = [UIColor whiteColor];
    box.layer.cornerRadius = 15;

    UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, box.frame.size.width - 40, 40)];
    input.placeholder = @"ضع الكود للاشتراك";
    input.borderStyle = UITextBorderStyleRoundedRect;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(20, 130, box.frame.size.width - 40, 40);
    [btn setTitle:@"تفعيل" forState:UIControlStateNormal];

    __weak UITextField *weakInput = input;

    [btn addTarget:nil action:@selector(dummy) forControlEvents:UIControlEventTouchUpInside];

    [btn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {

        if ([weakInput.text isEqualToString:@"MOSTAH77669"]) {

            saveActivation();

            UIAlertController *alert =
            [UIAlertController alertControllerWithTitle:@"تم التفعيل"
                                                message:@"اهلا تم تفعيل الاوتو الخاص في المطور موستاش استمتع🤗!"
                                         preferredStyle:UIAlertControllerStyleAlert];

            [window.rootViewController presentViewController:alert animated:YES completion:nil];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC),
                           dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });

            [bg removeFromSuperview];

        } else {

            exit(0);
        }

    }] forControlEvents:UIControlEventTouchUpInside];

    [box addSubview:input];
    [box addSubview:btn];
    [bg addSubview:box];

    [window addSubview:bg];
}

#pragma mark - ===== Floating Button =====

static void handleDrag(UIPanGestureRecognizer *pan) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [pan locationInView:window];
    floatingButton.center = point;
}

static void togglePanel() {
    panelVisible = !panelVisible;
    panel.hidden = !panelVisible;
}

static void createFloatingButton(UIWindow *window) {

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

#pragma mark - ===== Panel =====

static void createPanel(UIWindow *window) {

    panel = [[UIView alloc] initWithFrame:CGRectMake(50, 250, 260, 300)];
    panel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
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

        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        if (!isActivated()) {
            showActivationAlert(window);
        }

        createFloatingButton(window);
        createPanel(window);
    });
}

%end
