#line 1 "Tweak.xm"
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
-(void)removeFromSuperview;
-(id) backgroundMaterialView;
-(id) _headerContentView;
-(id) _customContentView;
@end
@interface _UIBackdropView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@end
static NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.plist" stringByExpandingTildeInPath]]; 
static BOOL bgEnabled;
static BOOL headerEnabled;
static BOOL mainEnabled;
static BOOL iconEnabled;
static BOOL iconBgEnabled;
static BOOL dominantEnabled;
static BOOL mtEnabled;
static CGFloat bgAlpha;
static BOOL solidBg;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class WGWidgetPlatterView; @class MTMaterialView; 
static void (*_logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$)(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$WGWidgetPlatterView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$WGWidgetPlatterView$setIcon$)(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$WGWidgetPlatterView$setIcon$(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL, id); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$MTMaterialView(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("MTMaterialView"); } return _klass; }
#line 33 "Tweak.xm"


static void _logos_method$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) { 
        if(bgEnabled) {
                return _logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(self, _cmd, NO);
        } else {
                return _logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(self, _cmd, YES);
        }
}
static void _logos_method$_ungrouped$WGWidgetPlatterView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
        
        if(solidBg) {
                for(UIView *subview in self.subviews) {
                        if([subview isKindOfClass:[_logos_static_class_lookup$MTMaterialView() class]]) {
                                [subview removeFromSuperview];
                        }
                }
        }

        if(iconBgEnabled) {
                if (self.icon) {
                        if(dominantEnabled) {
                                CCColorCube *colorCube = [[CCColorCube alloc] init];
                                
                                CGFloat setAlpha = bgAlpha;
                                UIImage *img = (UIImage *)self.icon;
                                UIColor *rgbBlack = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                                NSArray *imgColors = [colorCube extractBrightColorsFromImage:img avoidColor:rgbBlack count:4];
                                UIColor *backColor = [imgColors[0] colorWithAlphaComponent:setAlpha];

                                
                                UIView *headerView = MSHookIvar<UIView *>(self, "_headerOverlayView");
                                headerView.backgroundColor = backColor;
                                
                                UIView *mainView = MSHookIvar<UIView *>(self, "_mainOverlayView");
                                mainView.backgroundColor = backColor;
                        } else {
                                CCColorCube *colorCube = [[CCColorCube alloc] init];
                                
                                CGFloat setAlpha = bgAlpha;
                                UIImage *img = (UIImage *)self.icon;
                                UIColor *rgbBlack = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
                                NSArray *imgColors = [colorCube extractBrightColorsFromImage:img avoidColor:rgbBlack count:4];
                                UIColor *backColor = [imgColors[0] colorWithAlphaComponent:setAlpha];

                                
                                UIView *headerView = MSHookIvar<UIView *>(self, "_headerOverlayView");
                                headerView.backgroundColor = backColor;
                                
                                UIView *mainView = MSHookIvar<UIView *>(self, "_mainOverlayView");
                                mainView.backgroundColor = backColor;
                        }
                }
        }
        if(mtEnabled) {
                MSHookIvar<UIView *>(self, "_headerOverlayView").hidden = true; 
                MSHookIvar<UIView *>(self, "_mainOverlayView").hidden = true; 
                MSHookIvar<MTMaterialView *>(self, "_backgroundView").hidden = true; 
        }
        
        if(headerEnabled) {
                _logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews(self, _cmd);
                NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
                UIView *headerView = MSHookIvar<UIView *>(self, "_headerOverlayView");
                headerView.backgroundColor = LCPParseColorString([colorData objectForKey:@"kMainColor"], @"FF0000"); 
        } else { _logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews(self, _cmd); }
        
        if(mainEnabled) {
                NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
                UIView *mainView = MSHookIvar<UIView *>(self, "_mainOverlayView");
                mainView.backgroundColor = LCPParseColorString([colorData objectForKey:@"mMainColor"], @"FF0000"); 
        } else { _logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews(self, _cmd); }

}
static void _logos_method$_ungrouped$WGWidgetPlatterView$setIcon$(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1){ 
        if(iconEnabled) {
                return _logos_orig$_ungrouped$WGWidgetPlatterView$setIcon$(self, _cmd, nil);
        } else { _logos_orig$_ungrouped$WGWidgetPlatterView$setIcon$(self, _cmd, arg1); }
}


static void loadPrefs() {
        static NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.plist"]; 
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

static __attribute__((constructor)) void _logosLocalCtor_94b0abe3(int __unused argc, char __unused **argv, char __unused **envp) {
        NSAutoreleasePool *pool = [NSAutoreleasePool new];
        loadPrefs();
        [pool release];
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$WGWidgetPlatterView = objc_getClass("WGWidgetPlatterView"); MSHookMessageEx(_logos_class$_ungrouped$WGWidgetPlatterView, @selector(setBackgroundBlurred:), (IMP)&_logos_method$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$, (IMP*)&_logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$);MSHookMessageEx(_logos_class$_ungrouped$WGWidgetPlatterView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$WGWidgetPlatterView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews);MSHookMessageEx(_logos_class$_ungrouped$WGWidgetPlatterView, @selector(setIcon:), (IMP)&_logos_method$_ungrouped$WGWidgetPlatterView$setIcon$, (IMP*)&_logos_orig$_ungrouped$WGWidgetPlatterView$setIcon$);} }
#line 149 "Tweak.xm"
