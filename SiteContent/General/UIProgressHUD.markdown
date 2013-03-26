

Part of the iPhone [[UIKit]] framework. Defined in <[[UIKit]]/[[UIProgressHUD]].h>

<code>
- (void)showProgressHUD:([[NSString]] '')label withWindow:([[UIWindow]] '')w withView:([[UIView]] '')v withRect:(struct [[CGRect]])rect
{
        progress = [[[[UIProgressHUD]] alloc] initWithWindow: w];
        [progress setText: label];
        [progress drawRect: rect];
        [progress show: YES];

        [v addSubview:progress];
}

- (void)hideProgressHUD
{
        [progress show: NO];
        [progress removeFromSuperview];
}
</code>

----
You can also use [[MBProgressHUD]] as an alternative if you want to avoid Apple's private API. http://www.bukovinski.com/2009/04/08/mbprogresshud-for-iphone/