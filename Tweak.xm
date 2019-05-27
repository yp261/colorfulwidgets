#import "libcolorpicker.h"
#import "CCColorCube.h"
@interface MTPlatterHeaderContentView : UIView
@end
@interface _UIBackdropEffectView : UIView
@end
@interface MTMaterialView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end
@interface WGWidgetPlatterView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@property (nonatomic, copy, readwrite) UIImage *icon;
@property (nonatomic, copy) NSArray *icons;
-(void)removeFromSuperview;
-(id) backgroundMaterialView;
-(id) _headerContentView;
-(id) _customContentView;
@end
@interface _UIBackdropView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end
static NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.plist" stringByExpandingTildeInPath]]; //Load settings the old way.
static BOOL bgEnabled;
static BOOL headerEnabled;
static BOOL mainEnabled;
static BOOL iconEnabled;
static BOOL iconBgEnabled;
static BOOL dominantEnabled;
static BOOL mtEnabled;
static CGFloat bgAlpha;
static BOOL solidBg;

UIImage* getIconForPlatter(WGWidgetPlatterView* platter) {
    if ([platter respondsToSelector:@selector(icon)])
        return platter.icon;
    else if (platter.icons.count > 0)
        return platter.icons[0];
    return nil;
}

%hook WGWidgetPlatterView

-(void)setBackgroundBlurred: (BOOL)arg1 { //disable blur for background
        if(bgEnabled) {
                return %orig(NO);
        } else {
                return %orig(YES);
        }
}
-(void)layoutSubviews {
        //get rid of the annoying white background
        if(solidBg) {
                for(UIView *subview in self.subviews) {
                        if([subview isKindOfClass:[%c(MTMaterialView) class]]) {
                                [subview removeFromSuperview];
                        }
                }
        }

        if(iconBgEnabled) {
                if (getIconForPlatter(self)) {
                        if(dominantEnabled) {
                                CCColorCube *colorCube = [[CCColorCube alloc] init];
                                //get color from image
                                CGFloat setAlpha = bgAlpha;
                                UIImage *img = (UIImage *)getIconForPlatter(self);
                                UIColor *rgbBlack = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                                NSArray *imgColors = [colorCube extractBrightColorsFromImage:img avoidColor:rgbBlack count:4];
                                UIColor *backColor = [imgColors[0] colorWithAlphaComponent:setAlpha];

                                //top view
                                UIView *headerView = MSHookIvar<UIView *>(self, "_headerOverlayView");
                                headerView.backgroundColor = backColor;
                                //bottom view
                                UIView *mainView = MSHookIvar<UIView *>(self, "_mainOverlayView");
                                mainView.backgroundColor = backColor;
                        } else {
                                CCColorCube *colorCube = [[CCColorCube alloc] init];
                                //get color from image
                                CGFloat setAlpha = bgAlpha;
                                UIImage *img = (UIImage *)getIconForPlatter(self);
                                UIColor *rgbBlack = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
                                NSArray *imgColors = [colorCube extractBrightColorsFromImage:img avoidColor:rgbBlack count:4];
                                UIColor *backColor = [imgColors[0] colorWithAlphaComponent:setAlpha];

                                //top view
                                UIView *headerView = MSHookIvar<UIView *>(self, "_headerOverlayView");
                                headerView.backgroundColor = backColor;
                                //bottom view
                                UIView *mainView = MSHookIvar<UIView *>(self, "_mainOverlayView");
                                mainView.backgroundColor = backColor;
                        }
                }
        }
        if(mtEnabled) {
                MSHookIvar<UIView *>(self, "_headerOverlayView").hidden = true; //hide header overlay
                MSHookIvar<UIView *>(self, "_mainOverlayView").hidden = true; //hide main overlay
                MSHookIvar<MTMaterialView *>(self, "_backgroundView").hidden = true; //disable background entirely
        }
        //header
        if(headerEnabled) {
                %orig;
                NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
                UIView *headerView = MSHookIvar<UIView *>(self, "_headerOverlayView");
                headerView.backgroundColor = LCPParseColorString([colorData objectForKey:@"kMainColor"], @"FF0000"); //set new color to the header overlay
        } else { %orig; }
        //main
        if(mainEnabled) {
                NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
                UIView *mainView = MSHookIvar<UIView *>(self, "_mainOverlayView");
                mainView.backgroundColor = LCPParseColorString([colorData objectForKey:@"mMainColor"], @"FF0000"); //set new color to the main overlay
        } else { %orig; }

}
-(void)setIcon: (id)arg1{ //hide icons
        if(iconEnabled) {
                return %orig(nil);
        } else { %orig; }
}
%end
//prefs
static void loadPrefs() {
        static NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.plist"]; //Load settings the old way.
        if(!preferences) {
                preferences = [[NSMutableDictionary alloc] init];
                bgEnabled = NO;
                headerEnabled = NO;
                mainEnabled = NO;
                iconEnabled = NO;
                mtEnabled = NO;
                iconBgEnabled = NO;
                bgAlpha = 1;
                dominantEnabled = NO;
                solidBg = NO;
        } else if(![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"]) {
                NSMutableDictionary * colorData = [[NSMutableDictionary alloc] init];
                [colorData writeToFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist" atomically:YES];
        } else {
                bgEnabled = [[preferences objectForKey:@"kEnabled"] boolValue];
                headerEnabled = [[preferences objectForKey:@"hEnabled"] boolValue];
                mainEnabled = [[preferences objectForKey:@"mEnabled"] boolValue];
                iconEnabled = [[preferences objectForKey:@"iEnabled"] boolValue];
                mtEnabled = [[preferences objectForKey:@"mtEnabled"] boolValue];
                iconBgEnabled = [[preferences objectForKey:@"iconBgEnabled"] boolValue];
                bgAlpha = [[preferences valueForKey:@"bgAlpha"] floatValue];
                dominantEnabled = [[preferences valueForKey:@"dominantEnabled"] boolValue];
                solidBg = [[preferences valueForKey:@"solidBg"] boolValue];
        }
        [preferences release];
}

%ctor {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        loadPrefs();
        [pool release];
}
