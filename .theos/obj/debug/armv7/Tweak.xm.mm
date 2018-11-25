#line 1 "Tweak.xm"
#import "libcolorpicker.h"
@interface MTPlatterHeaderContentView : UIView
@end
@interface WGWidgetPlatterView : UIView
@property (nonatomic, assign, readwrite, getter=isHidden) BOOL hidden;
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

static NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.plist" stringByExpandingTildeInPath]]; 
static BOOL bgEnabled;
static BOOL headerEnabled;
static BOOL mainEnabled;


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

@class WGWidgetPlatterView; 
static void (*_logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$)(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL, BOOL); static void (*_logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews)(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$WGWidgetPlatterView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST, SEL); 

#line 14 "Tweak.xm"

static void _logos_method$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
  if(bgEnabled){
    return _logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(self, _cmd, NO);
  } else {
    return _logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$(self, _cmd, YES);
  }
}
static void _logos_method$_ungrouped$WGWidgetPlatterView$layoutSubviews(_LOGOS_SELF_TYPE_NORMAL WGWidgetPlatterView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  for(UIView *subviews in self.subviews) {
      if([subviews isKindOfClass:[MTPlatterHeaderContentView class]]) {
          [subviews removeFromSuperview];
      }
  }
  if(headerEnabled){
  _logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews(self, _cmd);
  NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
  UIView *headerView = MSHookIvar<UIView *>(self, "_headerOverlayView");
  headerView.backgroundColor = LCPParseColorString([colorData objectForKey:@"kMainColor"], @"FF0000");
  } else { _logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews(self, _cmd); }

  if(mainEnabled){
  NSMutableDictionary * colorData = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"];
  UIView *mainView = MSHookIvar<UIView *>(self, "_mainOverlayView");
  mainView.backgroundColor = LCPParseColorString([colorData objectForKey:@"mMainColor"], @"FF0000");
  } else { _logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews(self, _cmd); }


}



static void loadPrefs() {
  static NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.plist"]; 
  if(!preferences) {
    preferences = [[NSMutableDictionary alloc] init];
    bgEnabled = NO;
    headerEnabled = NO;
    mainEnabled = NO;
    } else if(![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist"]) {
    NSMutableDictionary * colorData = [[NSMutableDictionary alloc] init];
    [colorData writeToFile:@"/var/mobile/Library/Preferences/com.morwi.colorfulwidgetsprefs.color.plist" atomically:YES];
  } else {
		bgEnabled = [[preferences objectForKey:@"kEnabled"] boolValue];
    headerEnabled = [[preferences objectForKey:@"hEnabled"] boolValue];
    mainEnabled = [[preferences objectForKey:@"mEnabled"] boolValue];
	}
	[preferences release];
}

static __attribute__((constructor)) void _logosLocalCtor_4bc127fe(int __unused argc, char __unused **argv, char __unused **envp) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	loadPrefs();
  [pool release];
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$WGWidgetPlatterView = objc_getClass("WGWidgetPlatterView"); MSHookMessageEx(_logos_class$_ungrouped$WGWidgetPlatterView, @selector(setBackgroundBlurred:), (IMP)&_logos_method$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$, (IMP*)&_logos_orig$_ungrouped$WGWidgetPlatterView$setBackgroundBlurred$);MSHookMessageEx(_logos_class$_ungrouped$WGWidgetPlatterView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$WGWidgetPlatterView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$WGWidgetPlatterView$layoutSubviews);} }
#line 69 "Tweak.xm"
