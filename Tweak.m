
float velocityJudge;
int appCount;

@interface SBAppSliderController : UIViewController
{
    NSMutableArray *_appList;
}

- (void)_quitAppAtIndex:(unsigned int)arg1;
- (void)forceDismissAnimated:(BOOL)arg1;
- (UIScrollView *)pageForDisplayIdentifier:(id)arg1;

@end

%hook SBAppSliderController

- (void)switcherWasPresented:(_Bool)arg1
{
    NSMutableArray *appList = MSHookIvar<NSMutableArray *>(self, "_appList");
    appCount = [appList count];
    
    %orig;
}

- (void)sliderScrollerDidEndScrolling:(UIViewController *)viewController
{
    NSMutableArray *appList = MSHookIvar<NSMutableArray *>(self, "_appList");
    
    if (velocityJudge <= -1.0f)
    {
        [UIView animateWithDuration:0.3f animations:^(void)
         {
            if (appList.count > 1)
            {
                for (int i = appList.count - 1; i > 0; i --)
                {
                    [self _quitAppAtIndex:i];
                }
            }
         }
         completion:^(BOOL Finish)
         {
            [self forceDismissAnimated:YES];
             velocityJudge = 0.0f;
         }];
    }
    
    %orig;
}

- (void)_quitAppAtIndex:(unsigned int)arg1
{
    //NSMutableArray *appList = MSHookIvar<NSMutableArray *>(self, "_appList");
    /*UIScrollView *onePage = (UIScrollView *)[[self pageForDisplayIdentifier:[appList objectAtIndex:arg1]] superview];
    [UIView animateWithDuration:0.9f animations:^(void)
     {
         //onePage.frame = CGRectMake(onePage.frame.origin.x, -1024.0f, onePage.frame.size.width, onePage.frame.size.height);
         //onePage.alpha = 0.0f;
     }
    completion:^(BOOL Finish)
     {*/
        %orig;
     //}];
}

%end

%hook SBAppSliderScrollingViewController

%new(v@:@@)
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[Suu Touch] %@",touches);
}

- (void)scrollViewWillEndDragging:(UIView *)view withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint)offset
{
    velocityJudge = velocity.y;
    if ((velocityJudge <= -1.0f) && (appCount > 1))
    {
        [UIView animateWithDuration:0.9f animations:^(void)
         {
            view.frame = CGRectMake(view.frame.origin.x, 1024.0f, view.frame.size.width, view.frame.size.height);
             view.alpha = 0.0f;
         }];
    }
    
	%orig;
}

%end